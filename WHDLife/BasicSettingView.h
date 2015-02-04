//
//  BasicSettingView.h
//  WHDLife
//
//  Created by Seven on 15-1-15.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicSettingView : UIViewController

@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIButton *clearCacheBtn;
@property (weak, nonatomic) IBOutlet UILabel *pushLb;
- (IBAction)clearCacheAction:(id)sender;
- (IBAction)pushStartAction:(id)sender;

@end
