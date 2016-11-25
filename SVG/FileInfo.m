//
//  SVGFile.m
//  SVG
//
//  Created by xiangwei wang on 10/18/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import "FileInfo.h"

#import "SVGKSourceLocalFile.h"
#import "SVGKSourceURL.h"

static float renderSizes[] = {20, 29, 40, 60, 70, 83.5};

@implementation FileInfo

-(SVGKSource*) sourceFromLocalFile {
    return [SVGKSourceLocalFile sourceFromFilename:self.filePath];
}

//-(NSArray *) pngFileNames {
//    NSMutableArray *array = [NSMutableArray array];
//    
//    for(int i = 0; i < 6; i++) {
//        NSString *path = [[self.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%g_1x.png", renderSizes[i]]];
//        [array addObject:path];
//        path = [[self.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%g_2x.png", renderSizes[i]]];
//        [array addObject:path];
//        path = [[self.filePath stringByDeletingPathExtension] stringByAppendingString:[NSString stringWithFormat:@"%g_3x.png", renderSizes[i]]];
//        [array addObject:path];
//    }
//    return array;
//}
@end
