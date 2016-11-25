//
//  SVGCollectionViewController.h
//  SVG
//
//  Created by xiangwei wang on 10/17/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InMobiSDK/InMobiSDK.h>

@interface SVGCollectionViewController : UICollectionViewController<UIDocumentPickerDelegate, UITextFieldDelegate, IMBannerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) IMBanner *banner;
@end
