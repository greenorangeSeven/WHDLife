//
//  ChangePwdView.h
//  WHDLife
//
//  Created by Seven on 15-1-25.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdView : UIViewController

@property (weak, nonatomic) UIView *parentView;

@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPassWordTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPassWordAginTf;

@end
