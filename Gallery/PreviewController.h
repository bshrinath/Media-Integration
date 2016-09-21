//
//  PreviewController.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

/*
 Initialize the elements required to display the selected image
 from the TableView in a separate View.
 */

@interface PreviewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;

@property (weak, nonatomic) IBOutlet UINavigationBar *fullImageTopBar;

@property (weak, nonatomic) IBOutlet UINavigationItem *fullImageLabel;

@property (nonatomic, strong) UIImage *displayImage;

@property (nonatomic, strong) ALAsset *assetInfo;

@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *modelAndVersion;
@property (strong, nonatomic) NSString *postString;



@end
