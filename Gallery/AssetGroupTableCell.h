//
//  AssetGroupTableCell.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetGroupTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *assetImageView1;
@property (nonatomic, strong) IBOutlet UIImageView *assetImageView2;
@property (nonatomic, strong) IBOutlet UIImageView *assetImageView3;
@property (nonatomic, strong) IBOutlet UIImageView *assetImageView4;

@property (nonatomic, strong) IBOutlet UIButton *assetButton1;
@property (nonatomic, strong) IBOutlet UIButton *assetButton2;
@property (nonatomic, strong) IBOutlet UIButton *assetButton3;
@property (nonatomic, strong) IBOutlet UIButton *assetButton4;

@end
