//
//  FirstViewController.m
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//  Reference: Course Example & StackOverflow
//

#import "FirstViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetGroupViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Asset Groups"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self setupAssetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewAssetGroup"])
    {
        NSIndexPath *indexPath =
        [_assetGroupTableView indexPathForSelectedRow];
        
        NSDictionary *selectedDict =
        [_assetGroupArray objectAtIndex:indexPath.row];
        
        [self setSelectedGroupURL:
         [selectedDict objectForKey:@"groupURL"]];
        
        AssetGroupViewController *aVC =
        segue.destinationViewController;
        
        [aVC setAssetGroupURL:[self selectedGroupURL]];
        
        [aVC setAssetGroupName:
         [selectedDict objectForKey:@"groupLabelText"]];
        
        [_assetGroupTableView
         deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - Table methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnCount = 0;
    
    if (_assetGroupArray) {
        returnCount = [_assetGroupArray count];
    }
    return returnCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetLibraryTableCell" forIndexPath:indexPath];
    
    
    NSDictionary *cellDict =
    [_assetGroupArray objectAtIndex:indexPath.row];
    
    [cell.textLabel
     setText:[cellDict objectForKey:@"groupLabelText"]];
    
    [cell.detailTextLabel

     setText:[cellDict objectForKey:@"groupInfoText"]];
    
    [cell.imageView
     setImage:[cellDict objectForKey:@"groupPosterImage"]];
    
    return cell;
}

#pragma mark - View lifecycle

- (void)setupAssetData
{
    ALAssetsLibrary *al =
    [[ALAssetsLibrary alloc] init];
    
    NSMutableArray *setupArray = [[NSMutableArray alloc] init];
    
    void (^enumerateAssetGroupsBlock)(ALAssetsGroup*, BOOL*) =
    ^(ALAssetsGroup* group, BOOL* stop) {
        if (group)
        {
            NSUInteger numAssets = [group numberOfAssets];
            
            NSString *groupName =
            [group valueForProperty:ALAssetsGroupPropertyName];
            NSLog(@"Group: %@, editable: %d",groupName, [group isEditable]);
            
            NSURL *groupURL =
            [group valueForProperty:ALAssetsGroupPropertyURL];
            
            NSString *groupLabelText =
            [NSString stringWithFormat:@"%@ (%lu)",groupName, (unsigned long)numAssets];
            
            UIImage *posterImage =
            [UIImage imageWithCGImage:[group posterImage]];
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSInteger groupPhotos = [group numberOfAssets];
            
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            NSInteger groupVideos = [group numberOfAssets];
            
            NSString *info = @"%d photos, %d videos in group";
            NSString *groupInfoText =
            [NSString stringWithFormat:info ,groupPhotos, groupVideos];
            
            NSDictionary *groupDict =
            @{@"groupLabelText": groupLabelText,
             @"groupURL":groupURL,
              @"groupPosterImage":posterImage,
              @"groupInfoText":groupInfoText};
            
            [setupArray addObject:groupDict];
        }
        else
        {
            [self setAssetGroupArray:
             [NSArray arrayWithArray:setupArray]];
            
            [_assetGroupTableView reloadData];
        }
    };
    
    void (^assetGroupEnumErrorBlock)(NSError*) =
    ^(NSError* error) {
        
        NSString *msgError =
        @"Cannot access asset library groups. \n"
        "Visit Privacy | Photos in Settings.app \n"
        "to restore permission.";
        
        UIAlertView* alertView =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:msgError
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alertView show];
    };
    
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:enumerateAssetGroupsBlock
                    failureBlock:assetGroupEnumErrorBlock];
    
}

@end
