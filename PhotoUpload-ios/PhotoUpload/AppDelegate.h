//
//  AppDelegate.h
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-25.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,ASIHTTPRequestDelegate>
{
    CLLocationManager * gpsManager;
    CLLocation * location;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    BOOL isgps;
    BOOL isopen;

}

@property (strong, nonatomic) UIWindow *window;

@end
