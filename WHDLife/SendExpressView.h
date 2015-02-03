//
//  SendExpressView.h
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendExpressView : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIView *frameView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIv;
@property (weak, nonatomic) IBOutlet UITextView *describeTv;
@property (weak, nonatomic) IBOutlet UITextField *bournTf;
@property (weak, nonatomic) IBOutlet UITextField *directionTf;
@property (weak, nonatomic) IBOutlet UITextField *gatherDateTf;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *expressCompanyTf;
- (IBAction)cameraAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
