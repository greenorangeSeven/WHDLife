//
//  ActivityInitiateView.h
//  WHDLife
//
//  Created by Seven on 15-1-7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityInitiateView : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *parentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIv;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;
@property (weak, nonatomic) IBOutlet UITextField *contactManTf;
@property (weak, nonatomic) IBOutlet UITextField *cutOffTimeTf;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTf;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTf;
@property (weak, nonatomic) IBOutlet UITextView *totalTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTf;

- (IBAction)cameraAction:(id)sender;
- (IBAction)createAction:(id)sender;

@end
