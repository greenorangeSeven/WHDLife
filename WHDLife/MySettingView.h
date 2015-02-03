//
//  MySettingView.h
//  WHDLife
//
//  Created by Seven on 15-1-24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"

@interface MySettingView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIPickerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bg1View;
@property (weak, nonatomic) IBOutlet UIView *bg2View;

@property (weak, nonatomic) IBOutlet UIImageView *mybgImageIv;
@property (weak, nonatomic) IBOutlet UILabel *facebgLb;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UIButton *updateFaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateMyBgBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeHouseBtn;

- (IBAction)updateFaceAction:(id)sender;
- (IBAction)updateMyBgAction:(id)sender;
- (IBAction)changePwdAction:(id)sender;
- (IBAction)changeHouseAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNameTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@end
