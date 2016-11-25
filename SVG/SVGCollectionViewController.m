//
//  SVGCollectionViewController.m
//  SVG
//
//  Created by xiangwei wang on 10/17/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import "SVGCollectionViewController.h"
#import "SVGCollectionViewCell.h"
#import "SVGPNGCollectionViewController.h"
#import <Masonry/Masonry.h>
#import "FileInfo.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "IconSizeView.h"

@interface SVGCollectionViewController() {
    NSMutableArray<FileInfo *> *fileArray;
    CGFloat width;
    CGFloat height;
    CGSize size;
}
@end
@implementation SVGCollectionViewController
- (IBAction)customSize:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Icon Size"
                                                                             message:@""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSString *w = [[alertController textFields] objectAtIndex:0].text;
                                                          NSString *h = [[alertController textFields] objectAtIndex:1].text;
                                                          size.width = [w floatValue];
                                                          size.height = [h floatValue];
                                                          [self performSegueWithIdentifier:@"SVG" sender:self];
                                                      }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Width";
        textField.delegate = self;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Height";
        textField.delegate = self;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(IBAction)cleanTouched:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    for(NSString *file in array) {
        if([[file pathExtension] isEqualToString:@"png"]) {
            [[NSFileManager defaultManager] removeItemAtPath:[documentPath stringByAppendingPathComponent:file] error:nil];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(IBAction)deleteTouched:(id)sender {
    //NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    for(NSInteger i = [fileArray count] - 1; i>=0; i--) {
        FileInfo *fileInfo = [fileArray objectAtIndex:i];
        if(fileInfo.selected) {
            [fileArray removeObject:fileInfo];
            [[NSFileManager defaultManager] removeItemAtPath:fileInfo.filePath error:nil];
        }
    }
    [self.collectionView reloadData];
    
    int i = 0;
    for(FileInfo *fileInfo in fileArray) {
        if(fileInfo.selected) {
            i++;
            break;
        }
    }
    if(i > 0) {
        for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = YES;
        }
        [self.navigationItem.leftBarButtonItems objectAtIndex:1].enabled = YES;
    } else {
        for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = NO;
        }
        [self.navigationItem.leftBarButtonItems objectAtIndex:1].enabled = NO;
    }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(s.length != 0) {
        if([s floatValue] == 0) {
            return NO;
        }
    }
    return YES;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.banner load];
    
    size = CGSizeZero;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
    [self.navigationItem.leftBarButtonItems objectAtIndex:1].enabled = NO;
    fileArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        for(NSString *file in [fileManager contentsOfDirectoryAtPath:documentPath error:nil]) {
            NSString *path = [documentPath stringByAppendingPathComponent:file];
            NSDictionary *attrs = [fileManager attributesOfItemAtPath:path error:nil];
            
            FileInfo *fileInfo = [[FileInfo alloc] init];
            fileInfo.filePath = path;
            
            BOOL isDir = NO;
            [fileManager fileExistsAtPath:path isDirectory:&isDir];
            if(isDir && ![[path lastPathComponent] hasPrefix:@"."]) {
                fileInfo.directory = YES;
            } else if([[path lowercaseString] hasSuffix:@"svg"]) {
                unsigned long long fileSize = [attrs fileSize];
                NSDate *date = [attrs fileModificationDate];
                
                fileInfo.fileSize = fileSize;
                fileInfo.modifiedDate = date;
            } else {
                continue;
            }
            [fileArray addObject:fileInfo];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
-(void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Library";
    [self.flowLayout setHeaderReferenceSize:CGSizeMake(0, 0)];
    width = 300;
    height = 50;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        width = 728;
        height = 90;
    }
    self.banner = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, width, height)
                                      placementId:1476596268520
                                         delegate:self];
}

-(IBAction)importSVGFiles:(id)sender {
    UIDocumentPickerViewController *importMenu =
    [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.svg-image"]
                                                         inMode:UIDocumentPickerModeImport];
    importMenu.delegate = self;
    importMenu.popoverPresentationController.barButtonItem = sender;

    [self presentViewController:importMenu animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSError *error = nil;
        
        NSURL *localUrl = [NSURL fileURLWithPath:[documentPath stringByAppendingPathComponent:[url lastPathComponent]]];
        if ([fileManager fileExistsAtPath:localUrl.path] == YES) {
            [fileManager removeItemAtPath:localUrl.path error:&error];
        }
        [fileManager moveItemAtURL:url toURL:localUrl error:&error];
        if(error) {
            NSLog(@"failed");
        } else {
            NSDictionary *attrs = [fileManager attributesOfItemAtPath:localUrl.path error:nil];

            FileInfo *fileInfo = [[FileInfo alloc] init];
            fileInfo.filePath = localUrl.path;
            
            unsigned long long fileSize = [attrs fileSize];
            NSDate *date = [attrs fileModificationDate];
            
            fileInfo.fileSize = fileSize;
            fileInfo.modifiedDate = date;

            [fileArray addObject:fileInfo];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [fileArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVGCollectionViewCell *cell = (SVGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SVG" forIndexPath:indexPath];
    
    FileInfo *fileInfo = [fileArray objectAtIndex:indexPath.row];
    cell.fileNameLabel.text = [fileInfo.filePath lastPathComponent];
    if(fileInfo.isDirectory) {
        cell.fileSizeLabel.text = @"";
        cell.fileModificationDateLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else {
        cell.fileSizeLabel.text = [NSString stringWithFormat:@"%llu bytes", fileInfo.fileSize];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        cell.fileModificationDateLabel.text = [formatter stringFromDate: fileInfo.modifiedDate];
        cell.imageView.image = [UIImage imageNamed:@"svg"];
    }
    if(fileInfo.selected) {
        cell.selectImageView.image = [UIImage imageNamed:@"select"];
    } else {
        cell.selectImageView.image = nil;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        [view addSubview:self.banner];
        [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).with.offset(0);
            make.topMargin.equalTo(self.view.mas_top).with.offset(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        return view;
    }
    return nil;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FileInfo *fileInfo = [fileArray objectAtIndex:indexPath.row];
    fileInfo.selected = !fileInfo.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    int i = 0;
    for(FileInfo *fileInfo in fileArray) {
        if(fileInfo.selected) {
            i++;
            break;
        }
    }
    if(i > 0) {
        for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = YES;
        }
        [self.navigationItem.leftBarButtonItems objectAtIndex:1].enabled = YES;
    } else {
        for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = NO;
        }
        [self.navigationItem.leftBarButtonItems objectAtIndex:1].enabled = NO;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SVG"]) {
        SVGPNGCollectionViewController *controller = segue.destinationViewController;
        NSMutableArray *array = [NSMutableArray array];
        for(FileInfo *fileInfo in fileArray) {
            if(fileInfo.selected) {
                [array addObject:fileInfo];
            }
        }
        controller.svgArray = array;
        controller.size = size;
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

    [UIView animateWithDuration:0.2 animations:^{
        [self.flowLayout setHeaderReferenceSize:CGSizeMake(self.view.bounds.size.width, height)];
    }];
    [self.collectionView reloadData];
}
/**
 * Notifies the delegate that the banner has failed to load with some error.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    [UIView animateWithDuration:0.2 animations:^{
        [self.flowLayout setHeaderReferenceSize:CGSizeMake(0, 0)];
    }];
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


@end
