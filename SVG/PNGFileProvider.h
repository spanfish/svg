//
//  PNGFileProvider.h
//  SVG
//
//  Created by xiangwei wang on 10/19/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNGFileProvider : UIActivityItemProvider {
    NSString *_path;
}

- (instancetype)initWithPlaceholderItem:(id)placeholderItem filePath:(NSString *) path;
@end
