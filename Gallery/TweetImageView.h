//
//  TweetDisplayView.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TweetImageView : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *displayTweetWebView;

@property (weak,nonatomic) NSURL *imageURL;
@end
