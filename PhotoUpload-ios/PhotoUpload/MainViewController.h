//
//  MainViewController.h
//  PhotoUpload
//
//  Created by 许 芝光 on 13-3-25.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGImagePickerController.h"

@class ASIFormDataRequest;

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,AGImagePickerControllerDelegate>
{
    UILabel * pathLabel;
    UILabel * nameLabel;
    UILabel * passWordLabel;
    UITextField * pathText;
    UITextField * nameText;
    UITextField * passWordText;
    UIButton * loginBtn;
    NSMutableString * mpDate;
    UIProgressView * pv;
    NSMutableDictionary * mpUserInfo;

    ASIFormDataRequest * request;
    
}
@property (retain, nonatomic) ASIFormDataRequest *request;

@end
