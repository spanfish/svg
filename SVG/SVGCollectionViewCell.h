//
//  SVGCollectionViewCell.h
//  SVG
//
//  Created by xiangwei wang on 10/17/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileModificationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end
