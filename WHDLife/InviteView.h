//
//  InviteView.h
//  WHDLife
//
//  Created by Seven on 15-1-22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteView : UIViewController

@property (nonatomic, strong) UIView *parentView;

@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextView *smsContentTv;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendAction:(id)sender;

@end
