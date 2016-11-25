//
//  PNGCollectionViewCell.h
//  SVG
//
//  Created by xiangwei wang on 10/18/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNGCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *image1xView;
@property(nonatomic, weak) IBOutlet UIImageView *image2xView;
@property(nonatomic, weak) IBOutlet UIImageView *image3xView;
@property(nonatomic, weak) IBOutlet UILabel *sizeLabel;
@end
