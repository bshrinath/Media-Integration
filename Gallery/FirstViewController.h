//
//  FirstViewController.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *assetGroupArray;
@property (nonatomic, strong) IBOutlet UITableView *assetGroupTableView;
@property (nonatomic, strong) NSURL *selectedGroupURL;

- (void)setupAssetData;

@end
