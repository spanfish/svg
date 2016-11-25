//
//  PNGFileProvider.m
//  SVG
//
//  Created by xiangwei wang on 10/19/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import "PNGFileProvider.h"

@implementation PNGFileProvider

- (instancetype)initWithPlaceholderItem:(id)placeholderItem filePath:(NSString *) path {
    self = [super initWithPlaceholderItem:placeholderItem];
    _path = path;
    return self;
}
-(id) item {
    UIImage *image = [UIImage imageWithContentsOfFile:_path];
    NSLog(@"path:%@", _path);
    return UIImagePNGRepresentation(image);
}

// called to fetch data after an activity is selected. you can return nil.
- (nullable id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType {
    return [self item];
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    return [UIImage imageWithContentsOfFile:_path];;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(nullable UIActivityType)activityType {
    return [_path lastPathComponent];
}
- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(nullable UIActivityType)activityType {
    return @"public.png";
}
@end
