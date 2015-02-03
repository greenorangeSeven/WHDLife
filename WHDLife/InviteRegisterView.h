//
//  InviteRegisterView.h
//  WHDLife
//
//  Created by Seven on 15-1-27.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteRegisterView : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTf;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *userTypeTf;
@property (weak, nonatomic) IBOutlet UIButton *getValidataCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

- (IBAction)getValidateCodeAction:(id)sender;
- (IBAction)finishAction:(id)sender;

@end
