//
//  LoginView.h
//  WHDLife
//
//  Created by Seven on 15-1-3.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIViewController

- (IBAction)registerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;

- (IBAction)loginAction:(id)sender;
- (IBAction)findPasswordAction:(id)sender;
- (IBAction)visitorAction:(id)sender;

@end
