//
//  AssetGroupViewController.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AssetGroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) NSURL *assetGroupURL;
@property (nonatomic, strong) NSString *assetGroupName;
@property (nonatomic, strong) IBOutlet UITableView *assetTableView;
@property (nonatomic, strong) ALAsset *assetInfo;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) MPMoviePlayerController *theMP;

@property (nonatomic, strong) NSArray *photos;

+ (ALAssetsLibrary *)defaultAssetsLibrary;



@end
