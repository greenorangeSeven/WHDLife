//
//  MyFrameView.h
//  WHDLife
//
//  Created by Seven on 15-1-23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurseView.h"
#import "IntegralView.h"
#import "MyCollectView.h"
#import "MyPayBillView.h"

@interface MyFrameView : UIViewController

@property (strong, nonatomic) PurseView *purseView;
@property (strong, nonatomic) IntegralView *integralView;
@property (strong, nonatomic) MyCollectView *collectView;
@property (strong, nonatomic) MyPayBillView *payBillView;


@property (weak, nonatomic) IBOutlet UIImageView *mybgImageIv;
@property (weak, nonatomic) IBOutlet UILabel *facebgLb;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@property (weak, nonatomic) IBOutlet UIButton *purseBtn;
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)purseAction:(id)sender;
- (IBAction)integralAction:(id)sender;
- (IBAction)collectAction:(id)sender;
- (IBAction)billAction:(id)sender;
- (IBAction)orderAction:(id)sender;
- (IBAction)signinAction:(id)sender;

@end
