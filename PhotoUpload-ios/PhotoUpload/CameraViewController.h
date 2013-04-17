//
//  CameraViewController.h
//  PhotoUpload
//
//  Created by 许 芝光 on 13-4-7.
//  Copyright (c) 2013年 许 芝光. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASIFormDataRequest;

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITextField * uploadPath;
    UIImageView * imageView;
    UIButton * uploadBtn;
    UIButton * cancelBtn;
    
    NSMutableString * mpDate;
    UIProgressView * pv;
    NSMutableDictionary * mpUserInfo;
    
    ASIFormDataRequest * request;
}
@property (retain, nonatomic) ASIFormDataRequest *request;

@end
