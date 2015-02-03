//
//  RegisterStep1View.h
//  WHDLife
//
//  Created by Seven on 15-1-3.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStep1View : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *communityTf;
@property (weak, nonatomic) IBOutlet UITextField *regionTf;
@property (weak, nonatomic) IBOutlet UITextField *buildingTf;
@property (weak, nonatomic) IBOutlet UITextField *unitTf;
@property (weak, nonatomic) IBOutlet UITextField *houseNumTf;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)inviteRegisterAction:(id)sender;
- (IBAction)regServiceAction:(id)sender;

@end
