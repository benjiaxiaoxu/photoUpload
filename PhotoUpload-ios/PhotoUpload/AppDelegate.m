//
//  AppDelegate.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-25.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "JSON.h"
#import "FileManagerClass.h"

@implementation AppDelegate

- (void)dealloc
{
    [gpsManager release],gpsManager = nil;
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//初始化
    [FileManagerClass deleteFile];

    [self initMananger];
    isgps = YES;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController * mvc = [[MainViewController alloc]init];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [mvc release];
    self.window.rootViewController = nvc;
    [nvc release];
//    nvc.navigationBarHidden = YES;
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initMananger
{
    gpsManager = [[CLLocationManager alloc]init];
    gpsManager.desiredAccuracy = kCLLocationAccuracyBest;
    gpsManager.delegate = self;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    location = [locations objectAtIndex:0];
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
  
    if (isgps) {
        NSString * url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&language=zh-CN&sensor=true",latitude,longitude];
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setRequestMethod:@"GET"];
        [request setTag:201];
        [request startAsynchronous];
        [request setDelegate:self];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * lpDic = [[NSMutableDictionary alloc]init];
        [lpDic setObject:[NSString stringWithFormat:@"%lf",latitude] forKey:@"latitude"];
        [lpDic setObject:[NSString stringWithFormat:@"%lf",longitude] forKey:@"longitude"];
        [userDefaults setObject:lpDic forKey:@"location"];
        [lpDic release];
        [userDefaults synchronize];
        
    }
    //设置请求定位只定位一次
    isgps = NO;
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"对不起！！" message:@"地理位置读取失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSMutableDictionary * lpDic = [[NSMutableDictionary alloc]init];

    
    NSString * messag = [request responseString];
    NSDictionary * jsonary = [messag JSONValue];
    NSArray * results = [jsonary objectForKey:@"results"];
    NSDictionary * temp1 = [results objectAtIndex:0];
    NSArray * address_components = [temp1 objectForKey:@"address_components"];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"gps" message:messag delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
    if ([address_components count] > 4) {
        //路
        NSDictionary * routeDic = [address_components objectAtIndex:0];
        //县
        NSDictionary * subCityDic = [address_components objectAtIndex:1];
        //市
        NSDictionary * cityDic = [address_components objectAtIndex:2];
        //省
        NSDictionary * provDic = [address_components objectAtIndex:3];
        //国
        NSDictionary * countryDic = [address_components objectAtIndex:4];
        [lpDic setObject:[NSNumber numberWithInt:5] forKey:@"count"];
        [lpDic setObject:[routeDic objectForKey:@"long_name"] forKey:@"route"];
        [lpDic setObject:[subCityDic objectForKey:@"long_name"] forKey:@"subCity"];
        [lpDic setObject:[cityDic objectForKey:@"long_name"] forKey:@"city"];
        [lpDic setObject:[provDic objectForKey:@"long_name"] forKey:@"prov"];
        [lpDic setObject:[countryDic objectForKey:@"long_name"] forKey:@"country"];

        
    }else
    {
        NSDictionary * routeDic = [address_components objectAtIndex:0];
        //市
        NSDictionary * cityDic = [address_components objectAtIndex:1];
        //省
        NSDictionary * provDic = [address_components objectAtIndex:2];
        //国
        NSDictionary * countryDic = [address_components objectAtIndex:3];
        [lpDic setObject:[NSNumber numberWithInt:4] forKey:@"count"];
        [lpDic setObject:[routeDic objectForKey:@"long_name"] forKey:@"route"];
        [lpDic setObject:[cityDic objectForKey:@"long_name"] forKey:@"city"];
        [lpDic setObject:[provDic objectForKey:@"long_name"] forKey:@"prov"];
        [lpDic setObject:[countryDic objectForKey:@"long_name"] forKey:@"country"];
        

    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:lpDic forKey:@"mapLocation"];
    [userDefaults synchronize];
    [lpDic release];
    [gpsManager stopUpdatingLocation];
}
//程序要进入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"mapLocation"];
}
//程序后台唤醒
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    isgps = YES;
    
}
//每次程序打开都走
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [gpsManager startUpdatingLocation];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
