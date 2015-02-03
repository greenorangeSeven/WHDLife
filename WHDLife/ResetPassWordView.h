//
//  ResetPassWordView.h
//  WHDLife
//
//  Created by Seven on 15-1-22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPassWordView : UIViewController

@property (nonatomic, strong) UIView *parentView;

@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTf;
@property (weak, nonatomic) IBOutlet UIButton *getValidataCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)getValidateCodeAction:(id)sender;
- (IBAction)finishAction:(id)sender;

@end
