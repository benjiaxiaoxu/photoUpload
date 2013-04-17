//
//  CameraViewController.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-4-7.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "CameraViewController.h"
#import "PathManager.h"
#import "ASIFormDataRequest.h"

@interface CameraViewController ()
- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation CameraViewController
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initUI
{
    uploadPath = [[UITextField alloc]initWithFrame:CGRectMake(60, 50, 200, 35)];
    uploadPath.borderStyle = UITextBorderStyleBezel;
    [uploadPath setText:@"http:\\\\"];
    
    [self.view addSubview:uploadPath];
    [uploadPath release];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, 200, 200)];
    [self.view addSubview:imageView];
    [imageView release];
    
    uploadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    uploadBtn.frame = CGRectMake(60, 320, 100, 40);
    uploadBtn.tag = 101;
    [uploadBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setTitle:@"上传" forState:UIButtonTypeCustom];
    [self.view addSubview:uploadBtn];
    
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(60, 320, 100, 40);
    cancelBtn.tag = 102;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIButtonTypeCustom];
    [self.view addSubview:cancelBtn];
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 101) {
        [self sendRequest];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark pickerCamera or photos
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * path = [[PathManager getCaches] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",mpDate]];
    [userDefaults setObject:mpDate forKey:@"imageInfo"];
    UIImage * mpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData * imageData = UIImageJPEGRepresentation(mpImage, 1.0);
    [imageData writeToFile:path atomically:YES];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //相机保存到本地
        UIImageWriteToSavedPhotosAlbum(mpImage, nil, nil, nil);
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{}];
//    [self sendRequest];
    //    [self aa];
}

-(void)sendRequest
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //
    NSMutableString * lat = [[NSMutableString alloc]init];
    NSMutableString * lon = [[NSMutableString alloc]init];
    NSMutableDictionary * locationDic = [userDefaults objectForKey:@"location"];
    if (locationDic) {
        [lat setString:[locationDic objectForKey:@"latitude"]];
        [lon setString:[locationDic objectForKey:@"longitude"]];
        
    }
    
    //
    NSMutableString * city = [[NSMutableString alloc]init];
    NSMutableString * prov = [[NSMutableString alloc]init];
    NSMutableString * country = [[NSMutableString alloc]init];
    NSMutableDictionary * mapLocationDic = [userDefaults objectForKey:@"mapLocation"];
    if (mapLocationDic) {
        [city setString:[mapLocationDic objectForKey:@"city"]];
        [prov setString:[mapLocationDic objectForKey:@"prov"]];
        [country setString:[mapLocationDic objectForKey:@"country"]];
    }
    
    //
    NSString * url = uploadPath.text;
    //@"http://allseeing-i.com/ignore"
    [request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]]];
    [request setPostValue:lat forKey:@"latitude"];
    [request setPostValue:lon forKey:@"longitude"];
    [request setPostValue:city forKey:@"city"];
    [request setPostValue:prov forKey:@"prov"];
    [request setPostValue:country forKey:@"county"];
    [request setTimeOutSeconds:30];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
	[request setDelegate:self];
	[request setDidFailSelector:@selector(uploadFailed:)];
	[request setDidFinishSelector:@selector(uploadFinished:)];
	
    
    NSString * path = [[PathManager getCaches] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[userDefaults objectForKey:@"imageInfo"]]];
    [request setFile:path forKey:@"image"];
    
    [request startAsynchronous];
    [lat release];
    [lon release];
    [city release];
    [prov release];
    [country release];
    
    
    
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"对不起！！" message:@"文件上传失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Clear out the old notification before scheduling a new one.
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Create a new notification
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    if (notification) {
		[notification setFireDate:[NSDate date]];
		[notification setTimeZone:[NSTimeZone defaultTimeZone]];
		[notification setRepeatInterval:0];
		[notification setSoundName:@"alarmsound.caf"];
		[notification setAlertBody:@"Boom!\r\n\r\nUpload is finished!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
#endif
}


#pragma mark actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2) {//防止取消进入图库
        
        UIImagePickerController * lpViewCtr = [[UIImagePickerController alloc]init];
        lpViewCtr.delegate = self;
        
        switch (buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    lpViewCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
                }else
                {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该设备没有相机功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    [alertView release];
                }
                
                break;
            case 1:
                lpViewCtr.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                break;
            case 2:
                break;
            default:
                break;
        }
        [self presentViewController:lpViewCtr animated:YES completion:nil];
        [lpViewCtr release];
    }
    
}



#pragma mark view
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userInfo = [userDefaults objectForKey:@"userInfo"];
    if (userInfo) {
    }
    NSDateFormatter * nsdf = [[[NSDateFormatter alloc]init] autorelease];
    [nsdf setDateStyle:NSDateFormatterShortStyle];
    [nsdf setDateFormat:@"YYMMDDHHmmssSSSS"];
    mpDate = [[NSMutableString alloc]init];
    [mpDate setString:[nsdf stringFromDate:[NSDate date]]];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
