//
//  SVGPNGCollectionViewController.m
//  SVG
//
//  Created by xiangwei wang on 10/18/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import "SVGPNGCollectionViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SVGKImage.h>
#import "SVGKSourceLocalFile.h"
#import "PNGCollectionViewCell.h"
#import "PNGHeadCollectionReusableView.h"
#import "PNGFileProvider.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"

@interface SVGPNGCollectionViewController () {
    UIPopoverController *activityPopover;
    CGSize renderSizes[6];
}
@end

@implementation SVGPNGCollectionViewController

static NSString * const reuseIdentifier = @"PNGCell";
static NSString * const reuseSectionIdentifier = @"Header";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Export to PNG";
    if(self.size.width != 0 && self.size.height != 0) {
        renderSizes[0] = _size;
        renderSizes[1] = CGSizeZero;
        renderSizes[2] = CGSizeZero;
        renderSizes[3] = CGSizeZero;
        renderSizes[4] = CGSizeZero;
        renderSizes[5] = CGSizeZero;
    } else {
        renderSizes[0] = CGSizeMake(20, 20);
        renderSizes[1] = CGSizeMake(29, 29);
        renderSizes[2] = CGSizeMake(40, 40);
        renderSizes[3] = CGSizeMake(60, 60);
        renderSizes[4] = CGSizeMake(76, 76);
        renderSizes[5] = CGSizeMake(83.5, 83.5);
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.collectionView setContentInset:UIEdgeInsetsZero];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    width = 300;
    height = 50;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        width = 728;
        height = 90;
    }
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if([app adEnabled]) {
        self.banner = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, width, height)
                                          placementId:1475686174437
                                             delegate:self];
        [self.banner load];
        self.fullScreenBanner = [[IMInterstitial alloc] initWithPlacementId:1475487453483 delegate:self];
        [self.fullScreenBanner load];
    
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self renderNext:0];
    });
}

-(void) renderNext:(NSUInteger) i {
    if(i < [self.svgArray count]) {
        FileInfo *fileInfo = [self.svgArray objectAtIndex:i];
        SVGKSource *svgSource = fileInfo.sourceFromLocalFile;
        [SVGKImage imageWithSource:svgSource onCompletion:^(SVGKImage *loadedImage, SVGKParseResult *parseResult) {
            if(loadedImage) {
                if(loadedImage.hasSize) {
                    for(int j = 0; j < 6; j++) {
                        loadedImage.size = renderSizes[j];
                        NSString *path = [[fileInfo.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%gx%g", renderSizes[j].width, renderSizes[j].height]];
                        [UIImagePNGRepresentation(loadedImage.UIImage) writeToFile:[path stringByAppendingString:@"_1x.png"] atomically:YES];
                        
                        loadedImage.size = CGSizeMake(renderSizes[j].width * 2, renderSizes[j].height * 2);
                        [UIImagePNGRepresentation(loadedImage.UIImage) writeToFile:[path stringByAppendingString:@"_2x.png"] atomically:YES];
                        
                        loadedImage.size = CGSizeMake(renderSizes[j].width * 3, renderSizes[j].height * 3);
                        [UIImagePNGRepresentation(loadedImage.UIImage) writeToFile:[path stringByAppendingString:@"_3x.png"] atomically:YES];
                    }
                }
            }
            [self renderNext:i + 1];
        }];
    } else {
        //end
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [[MBProgressHUD HUDForView:self.view].label setText:@"Finished"];
            [[MBProgressHUD HUDForView:self.view] hideAnimated:YES afterDelay:2];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.svgArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger i = 0;
    for(int j = 0; j < 6; j++) {
        if(renderSizes[j].width > 0) {
            i++;
        }
    }
    return i;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    FileInfo *fileInfo = [self.svgArray objectAtIndex:indexPath.section];
    NSString *path = [[fileInfo.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%gx%g", renderSizes[indexPath.row].width, renderSizes[indexPath.row].height]];
    if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingString:@"_1x.png"]]) {
        cell.image1xView.image = [UIImage imageWithContentsOfFile:[path stringByAppendingString:@"_1x.png"]];
    } else {
        cell.image1xView.image = nil;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingString:@"_2x.png"]]) {
        cell.image2xView.image = [UIImage imageWithContentsOfFile:[path stringByAppendingString:@"_2x.png"]];
    } else {
        cell.image2xView.image = nil;
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingString:@"_3x.png"]]) {
        cell.image3xView.image = [UIImage imageWithContentsOfFile:[path stringByAppendingString:@"_3x.png"]];
    } else {
        cell.image3xView.image = nil;
    }
    cell.sizeLabel.text = [NSString stringWithFormat:@"%gx%gpt", renderSizes[indexPath.row].width, renderSizes[indexPath.row].height];
    return cell;
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;

    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FileInfo *fileInfo = [self.svgArray objectAtIndex:indexPath.section];
        PNGHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseSectionIdentifier forIndexPath:indexPath];
        headView.fileNameLabel.text = [fileInfo.filePath lastPathComponent];
        reusableview = headView;
    }

    return reusableview;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark -
- (IBAction)openActivitySheet:(id)sender {
    //Create an activity view controller with the profile as its activity item. APLProfile conforms to the UIActivityItemSource protocol.
    NSMutableArray *images = [NSMutableArray array];
    for (FileInfo *fileInfo in self.svgArray) {
        for(int i = 0; i < 6; i++) {
            if(renderSizes[i].width > 0) {
                NSString *path = [[fileInfo.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%gx%g_1x.png", renderSizes[i].width, renderSizes[i].height]];
                
                PNGFileProvider *provider = [[PNGFileProvider alloc] initWithPlaceholderItem:[UIImage imageNamed:@"svg"] filePath:path];
                [images addObject:provider];
                
                path = [[fileInfo.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%gx%g_2x.png", renderSizes[i].width, renderSizes[i].height]];
                
                provider = [[PNGFileProvider alloc] initWithPlaceholderItem:[UIImage imageNamed:@"svg"] filePath:path];
                [images addObject:provider];
                
                path = [[fileInfo.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%gx%g_3x.png", renderSizes[i].width, renderSizes[i].height]];
                
                provider = [[PNGFileProvider alloc] initWithPlaceholderItem:[UIImage imageNamed:@"svg"] filePath:path];
                [images addObject:provider];
            }
            
        }
    }

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToTwitter,
                                                     UIActivityTypePostToWeibo,
                                                     UIActivityTypeMessage,
                                                     UIActivityTypeMail,
                                                     UIActivityTypePrint,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeOpenInIBooks,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypePostToTencentWeibo];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType,
                                                          BOOL completed,
                                                          NSArray * __nullable returnedItems,
                                                          NSError * __nullable activityError) {
        
        if([self.fullScreenBanner isReady]) {
            [self.fullScreenBanner showFromViewController:self];
        }
    };
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //iPhone, present activity view controller as is.
        [self presentViewController:activityViewController animated:YES completion:nil];
    } else {
        //iPad, present the view controller inside a popover.
        if (![activityPopover isPopoverVisible]) {
            activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [activityPopover presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                    animated:YES];
        }
        else
        {
            //Dismiss if the button is tapped while popover is visible.
            [activityPopover dismissPopoverAnimated:YES];
        }
    }
}

#pragma mark - AD
/**
 * Notifies the delegate that the banner has finished loading
 */
-(void)bannerDidFinishLoading:(IMBanner*)banner {
#if DEBUG
    NSLog(@"bannerDidFinishLoading");
#endif
    self.topConstraints.constant = 0;
    [self.view addSubview:self.banner];
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.mas_topLayoutGuideBottom).with.offset(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    self.topConstraints.constant = height;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    //[self.collectionView setContentInset:UIEdgeInsetsMake(height, 0, 0, 0)];
    //[self.collectionView reloadData];
}
/**
 * Notifies the delegate that the banner has failed to load with some error.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    self.topConstraints.constant = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];

    [self.banner removeFromSuperview];
#if DEBUG
    NSLog(@"didFailToLoadWithError:%@", error);
#endif
}

/**
 * Notifies the delegate that the banner was interacted with.
 */
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params {
#if DEBUG
    NSLog(@"didInteractWithParams:%@", params);
#endif
}
/**
 * Notifies the delegate that the user would be taken out of the application context.
 */
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
#if DEBUG
    NSLog(@"userWillLeaveApplicationFromBanner");
#endif
}

/**
 * Notifies the delegate that the banner would be presenting a full screen content.
 */
-(void)bannerWillPresentScreen:(IMBanner*)banner {
#if DEBUG
    NSLog(@"bannerWillPresentScreen");
#endif
}

/**
 * Notifies the delegate that the banner has finished presenting screen.
 */
-(void)bannerDidPresentScreen:(IMBanner*)banner {
#if DEBUG
    NSLog(@"bannerDidPresentScreen");
#endif
}

/**
 * Notifies the delegate that the banner will start dismissing the presented screen.
 */
-(void)bannerWillDismissScreen:(IMBanner*)banner {
#if DEBUG
    NSLog(@"bannerWillDismissScreen");
#endif
}

/**
 * Notifies the delegate that the banner has dismissed the presented screen.
 */
-(void)bannerDidDismissScreen:(IMBanner*)banner {
#if DEBUG
    NSLog(@"bannerDidDismissScreen");
#endif
}

/**
 * Notifies the delegate that the user has completed the action to be incentivised with.
 */
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards {
#if DEBUG
    NSLog(@"rewardActionCompletedWithRewards:%@", rewards);
#endif
}

/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
}
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    
}
@end
