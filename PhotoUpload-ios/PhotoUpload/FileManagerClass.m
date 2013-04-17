//
//  FileManagerClass.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-31.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "FileManagerClass.h"
#import "PathManager.h"
@implementation FileManagerClass
+(void)deleteFile
{
    @autoreleasepool {
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * cachesHome = [[PathManager getCaches] stringByExpandingTildeInPath];
        NSDirectoryEnumerator * direnum = [manager enumeratorAtPath:cachesHome];
        NSString * fileName;
        while (fileName = [direnum nextObject]) {
            if ([[fileName pathExtension] isEqualToString:@"jpg"]) {
                [manager removeItemAtPath:fileName error:nil];
            }
        }
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"imageInfo"];
    }
}
@end
