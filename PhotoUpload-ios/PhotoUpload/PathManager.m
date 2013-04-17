//
//  PathManager.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-31.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "PathManager.h"

@implementation PathManager
+(NSString *)getCaches
{
    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [searchPaths objectAtIndex:0];

}
@end
