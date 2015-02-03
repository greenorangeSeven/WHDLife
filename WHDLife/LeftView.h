//
//  LeftView.h
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"

@interface LeftView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIPickerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *facebgLb;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;

- (IBAction)updateFaceAcion:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)checkVersionUpdate:(id)sender;
- (IBAction)basicSettingAction:(id)sender;
- (IBAction)inviteAction:(id)sender;
- (IBAction)helpPageAction:(id)sender;

@end
