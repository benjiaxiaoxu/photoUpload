//
//  MainViewController.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-25.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoShowViewController.h"
#import "PathManager.h"
#import "ASIFormDataRequest.h"

#define labelX 30
#define textX 100
#define labelWidth 75
#define textWidth 200
#define higth 30
@interface MainViewController ()
- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest;
@end

@implementation MainViewController
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        mpUserInfo = [userDefaults objectForKey:@"userInfo"];
    }
    return self;
}

#pragma mark ui
-(void)startCarman
{
    if (!([pathText.text length]<=0 || [nameText.text length]<=0 || [passWordText.text length]<=0)) {
        NSMutableDictionary * lpDic = [[NSMutableDictionary alloc]init];
        [lpDic setObject:pathText.text forKey:@"path"];
        [lpDic setObject:nameText.text forKey:@"name"];
        [lpDic setObject:passWordText.text forKey:@"pass"];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:lpDic forKey:@"userInfo"];
        
        [userDefaults synchronize];
        [lpDic release];
    }
    
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择"
                                                       delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"图库", nil];
    [sheet showInView:self.view];
    [sheet release];
    
}
-(void)initUI
{
    // LABEL
    pathLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 80, labelWidth, higth)];
    pathLabel.text = @"地 址：";
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 140, labelWidth, higth)];
    nameLabel.text = @"用户名：";
    passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 200, labelWidth, higth)];
    passWordLabel.text = @"密 码：";
    [self.view addSubview:pathLabel];
    [self.view addSubview:nameLabel];
    [self.view addSubview:passWordLabel];
    [pathLabel release];
    [nameLabel release];
    [passWordLabel release];
    
    // TEXTFIELD
    pathText = [[UITextField alloc]initWithFrame:CGRectMake(textX, 80, textWidth, higth)];
    pathText.borderStyle = UITextBorderStyleBezel;
    [pathText setText:@"http:\\\\"];
    
    nameText = [[UITextField alloc]initWithFrame:CGRectMake(textX, 140, textWidth, higth)];
    nameText.placeholder = @"请输入用户名";
    nameText.borderStyle = UITextBorderStyleBezel;

    passWordText = [[UITextField alloc]initWithFrame:CGRectMake(textX, 200, textWidth, higth)];
    passWordText.placeholder = @"请输入密码";
    passWordText.secureTextEntry = YES;
    passWordText.borderStyle = UITextBorderStyleBezel;

    [self.view addSubview:pathText];
    [self.view addSubview:nameText];
    [self.view addSubview:passWordText];

    [pathText release];
    [nameText release];
    [passWordText release];

    
    //BUTTON
    loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(120, 260, 120, 40);
    [loginBtn addTarget:self action:@selector(startCarman) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pathText resignFirstResponder];
    [nameText resignFirstResponder];
    [passWordText resignFirstResponder];
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
    
    PhotoShowViewController * pvc = [[PhotoShowViewController alloc]init];
    [picker dismissViewControllerAnimated:NO completion:^{}];
    [self.navigationController pushViewController:pvc animated:YES];
    [pvc release];
    [self sendRequest];
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
    NSString * url = pathText.text;
    //@"http://allseeing-i.com/ignore"
    [request cancel];
    [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]]];
    [request setPostValue:nameText.text forKey:@"name"];
    [request setPostValue:passWordText.text forKey:@"password"];
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
        [pathText setText:[userInfo objectForKey:@"path"]];
        [nameText setText:[userInfo objectForKey:@"name"]];
        [passWordText setText:[userInfo objectForKey:@"pass"]];
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
-(void)dealloc
{
    [request setDelegate:nil];
	[request cancel];
	[request release];
    [mpDate release],mpDate = nil;
    [super dealloc];
}

@end
