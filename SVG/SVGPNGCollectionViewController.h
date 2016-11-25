//
//  SVGPNGCollectionViewController.h
//  SVG
//
//  Created by xiangwei wang on 10/18/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileInfo.h"
#import <InMobiSDK/InMobiSDK.h>

@interface SVGPNGCollectionViewController : UIViewController<UICollectionViewDelegate,  IMBannerDelegate, IMInterstitialDelegate> {
    CGFloat width;
    CGFloat height;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property(nonatomic, strong) IMBanner *banner;
@property(nonatomic, strong) IMInterstitial *fullScreenBanner;
@property(nonatomic, strong) NSArray<FileInfo *> *svgArray;
@property(nonatomic, assign) CGSize size;
@end
