//
//  PreviewController.m
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//  Reference: Course Example & StackOverflow
//

#import <Foundation/Foundation.h>
#import "PreviewController.h"
#import "Reachability.h"

@interface PreviewController()


@end

NSString *stringToTweet;
long output;

@implementation PreviewController

-(void)viewDidLoad{
    
    [self.fullImageView setImage:_displayImage];
    self.fullImageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size= self->_displayImage.size};
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [formatter setLocale:posix];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    NSDate *currentTimestamp = [NSDate date];
    
    NSString *prettyDate = [formatter stringFromDate:currentTimestamp];
    
    NSString *deviceType = [[UIDevice currentDevice] model];
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *final = [deviceType stringByAppendingString:@" "];
    final = [final stringByAppendingString:OSVersion];
    
    self.timeStamp.text = prettyDate;
    self.modelAndVersion.text = final;
    
    
    stringToTweet = [@"@AppSbadrina " stringByAppendingString:@"sbadrina "];
    stringToTweet = [stringToTweet stringByAppendingString:@" "];
    stringToTweet = [stringToTweet stringByAppendingString:prettyDate];
    
}


-(void) viewWillDisappear:(BOOL)animated {
    
    [self->_fullImageView setImage:nil];
    
}



+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (IBAction)onTweetImagePressed:(id)sender {
    
    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterAccountType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [twitterAccount requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         
         NSArray *accountArray = [twitterAccount accountsWithAccountType:twitterAccountType];
         
         Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
         NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
         if (networkStatus == NotReachable) {
             NSLog(@"Network connection not available");
             UIAlertView *noAccountAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                      message:@"Network connection is not available. Check your internet settings."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
             
             [noAccountAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             
         } //no network
         
         
         else {
             
             
             if(granted)
             {
                 if([accountArray count] == 0)
                 {
                     NSLog(@"No Twitter Account setup.");
                     UIAlertView *noAccountAlert = [[UIAlertView alloc] initWithTitle:@"Setup Twitter Account"
                                                                              message:@"You need to setup atleast one Twitter account in your Settings menu."
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                     
                     [noAccountAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                 }
                 
                 else if([accountArray count] > 0)
                 {
                     
                     ACAccount *twitterAccounts = [accountArray lastObject];
                     
                     NSDictionary *post = @{@"status": stringToTweet};
                     
                     NSURL *requestURL = [NSURL
                                          URLWithString:@"https://api.twitter.com/1/statuses/update_with_media.json"];
                     
                     NSData *imageData = UIImageJPEGRepresentation(_displayImage, 1);
                     
                     SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:post];
                     
                     [postRequest addMultipartData:imageData withName:@"media" type:@"image/png" filename:@"image.png"];
                     
                     postRequest.account = twitterAccounts;
                     
                     [postRequest
                      performRequestWithHandler:^(NSData *responseData,
                                                  NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                          NSLog(@"Twitter HTTP response: %li",
                                (long)[urlResponse statusCode]);
                          output = [urlResponse statusCode];
                          
                          if(output == 200)
                          {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeted"
                                                                              message:@"Your tweet has been posted."
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              
                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                          }
                          
                          if(output == 403)
                          {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"403 Forbidden"
                                                                              message:@"You cannot post the same tweet again."
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              
                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                          }
                          
                          if(output == 401)
                          {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unauthorized"
                                                                              message:@"Unauthorized - incorrect or missing credentials."
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              
                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                          }
                          
                          if(output == 500)
                          {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                              message:@"Internal Server Error"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              
                              [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                          }
                          
                          
                          
                          
                      }];
                     
                 }//else if
             }//if granted
             
             else
             {   NSLog(@"Permission not granted!");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                 message:@"You have denied permission for this app to access your Twitter. Change this in the Settings menu."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 
                 [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             }//else
             
         } // if network
     } ];

    
    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//        
//    {
//        
//        SLComposeViewController *tweetSheet = [SLComposeViewController
//                                               
//                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
//        
//        NSDate *date = [[NSDate alloc]init];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
//        
//        NSString *dateString = [dateFormatter stringFromDate:date];
//        
//        NSString *andrewID = @"sbadrina";
//        
//        [tweetSheet setInitialText: [NSString stringWithFormat:@"@MobileApp4 %@ %@",andrewID,dateString]];
//        
//        [tweetSheet addImage:self->_displayImage];
//        
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//        
//    } else {
//        
//        [self twitterExceptionHandling:@"Please Sign in to Twitter to post the picture"];
//    }
    
}

-(void)twitterExceptionHandling:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"User pressed Cancel");
                                   }];
    
    UIAlertAction *settingsAction = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Settings", @"Settings action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"Settings Pressed");
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         
                                     }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
