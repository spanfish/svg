//
//  SVGFile.h
//  SVG
//
//  Created by xiangwei wang on 10/18/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGKSource.h"
#import <UIKit/UIKit.h>

@interface FileInfo : NSObject

@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, assign, getter=isDirectory) BOOL directory;
@property(nonatomic, assign) unsigned long long fileSize;
@property(nonatomic, strong) NSDate *modifiedDate;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) BOOL selected;
-(SVGKSource*) sourceFromLocalFile;
//-(NSArray *) pngFileNames;
@end
