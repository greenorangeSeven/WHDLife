//
//  RegisterStep2View.h
//  WHDLife
//
//  Created by Seven on 15-1-3.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStep2View : UIViewController

@property (nonatomic, strong) NSString *houseNumId;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *regUserNameTf;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTf;
@property (weak, nonatomic) IBOutlet UIButton *getValidataCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

- (IBAction)getValidateCodeAction:(id)sender;
- (IBAction)finishAction:(id)sender;
- (IBAction)agreeAction:(id)sender;

- (IBAction)regServiceAction:(id)sender;

@end
