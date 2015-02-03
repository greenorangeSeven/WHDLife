//
//  GatherSelectView.h
//  WHDLife
//
//  Created by Seven on 15-1-15.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatherSelectView : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UIView *parentView;

@property (copy, nonatomic) NSString *expressId;

@property (weak, nonatomic) IBOutlet UIButton *type0Btn;
@property (weak, nonatomic) IBOutlet UIButton *type1Btn;
@property (weak, nonatomic) IBOutlet UITextField *dateTf;
@property (weak, nonatomic) IBOutlet UITextField *timeQuantumTf;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;

- (IBAction)type0Action:(id)sender;
- (IBAction)type1Action:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
