//
//  PhotoShowViewController.m
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-27.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import "PhotoShowViewController.h"
#import "PathManager.h"
@interface PhotoShowViewController ()

@end

@implementation PhotoShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)addImageView
{
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
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
        [city setString:[mapLocationDic objectForKey:@"city" ]];
        [prov setString:[mapLocationDic objectForKey:@"prov"]];
        [country setString:[mapLocationDic objectForKey:@"country"]];
    }

    NSString * path = [[PathManager getCaches] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[userDefaults objectForKey:@"imageInfo"]]];
    
    mpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 220)];
    mpImageView.image = [UIImage imageWithContentsOfFile:path];
    
    [self.view addSubview:mpImageView];
    [mpImageView release];
    
    UILabel * labelShow = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 320, 40)];
    labelShow.text = [NSString stringWithFormat:@"lat:%@  lon:%@  ",lat,lon];
    [self.view addSubview:labelShow];
    [labelShow release];

    UILabel * lbs1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 270, 320, 40)];
    lbs1.text = [NSString stringWithFormat:@"city:%@,prov:%@",city,prov];
    [self.view addSubview:lbs1];
    [lbs1 release];

    UILabel * lbs = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, 320, 40)];
    lbs.text = [NSString stringWithFormat:@"count:%@",country];
    [self.view addSubview:lbs];
    [lbs release];
    
    [lat release];
    [lon release];
    [city release];
    [prov release];
    [country release];
}

-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBtn
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 360, 120, 40);
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageView];
    [self addBtn];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
}

@end
