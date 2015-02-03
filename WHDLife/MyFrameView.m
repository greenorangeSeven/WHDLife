//
//  MyFrameView.m
//  WHDLife
//
//  Created by Seven on 15-1-23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MyFrameView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "MySettingView.h"
#import "MyOrderView.h"

@interface MyFrameView ()
{
    UserInfo *userInfo;
}

@end

@implementation MyFrameView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"我";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rBtn addTarget:self action:@selector(mySettingAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"mysetting"] forState:UIControlStateNormal];
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    
    //图片圆形处理
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius=self.faceIv.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    self.faceIv.backgroundColor = [UIColor whiteColor];
    
    self.facebgLb.layer.masksToBounds=YES;
    self.facebgLb.layer.cornerRadius=self.facebgLb.frame.size.width/2;    //最重要的是这个地方要设成view高的一半
    
    userInfo = [[UserModel Instance] getUserInfo];
    [self.faceIv setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    [self.mybgImageIv setImageWithURL:[NSURL URLWithString:userInfo.bgImgFull] placeholderImage:[UIImage imageNamed:@"my_bg"]];
    self.nickNameLb.text = userInfo.nickName;
    
    //下属控件初始化
    self.purseView = [[PurseView alloc] init];
    self.purseView.frameView = self.mainView;
    [self addChildViewController:self.purseView];
    [self.mainView addSubview:self.purseView.view];
}

- (void)mySettingAction:(id)sender
{
    MySettingView *mysettingView = [[MySettingView alloc] init];
    [self.navigationController pushViewController:mysettingView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController setNeedSwipeShowMenu:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)purseAction:(id)sender
{
    [self.purseBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.purseBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    [self.integralBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.integralBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.billBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.billBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    self.purseView.view.hidden = NO;
    self.integralView.view.hidden = YES;
    self.collectView.view.hidden = YES;
    self.payBillView.view.hidden = YES;
}

- (IBAction)integralAction:(id)sender
{
    [self.purseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.purseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.integralBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.integralBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    [self.collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.billBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.billBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    if (self.integralView == nil) {
        self.integralView = [[IntegralView alloc] init];
        self.integralView.frameView = self.mainView;
        [self addChildViewController:self.integralView];
        [self.mainView addSubview:self.integralView.view];
    }
    self.purseView.view.hidden = YES;
    self.integralView.view.hidden = NO;
    self.collectView.view.hidden = YES;
    self.payBillView.view.hidden = YES;
}

- (IBAction)collectAction:(id)sender
{
    [self.purseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.purseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.integralBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.integralBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.collectBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    [self.billBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.billBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    if (self.collectView == nil) {
        self.collectView = [[MyCollectView alloc] init];
        self.collectView.frameView = self.mainView;
        [self addChildViewController:self.collectView];
        [self.mainView addSubview:self.collectView.view];
    }
    self.purseView.view.hidden = YES;
    self.integralView.view.hidden = YES;
    self.collectView.view.hidden = NO;
    self.payBillView.view.hidden = YES;
}

- (IBAction)billAction:(id)sender
{
    [self.purseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.purseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.integralBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.integralBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.billBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.billBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    [self.orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderBtn setBackgroundImage:nil forState:UIControlStateNormal];
    if (self.payBillView == nil) {
        self.payBillView = [[MyPayBillView alloc] init];
        self.payBillView.frameView = self.mainView;
        [self addChildViewController:self.payBillView];
        [self.mainView addSubview:self.payBillView.view];
    }
    self.purseView.view.hidden = YES;
    self.integralView.view.hidden = YES;
    self.collectView.view.hidden = YES;
    self.payBillView.view.hidden = NO;
}

- (IBAction)orderAction:(id)sender
{
    MyOrderView *myOrder = [[MyOrderView alloc] init];
    [self.navigationController pushViewController:myOrder animated:YES];
}

- (IBAction)signinAction:(id)sender {
    //用户签到
    self.signInBtn.enabled = NO;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    
    NSString *signInUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_signin] params:param];
    [[AFOSCClient sharedClient] getPath:signInUrl parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                    NSLog(@"%@", operation.responseString);
                                    NSError *error;
                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                    
                                    NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                    if ([state isEqualToString:@"0000"] == NO) {
                                        [Tool showCustomHUD:[[json objectForKey:@"header"] objectForKey:@"msg"] andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                        
                                    }
                                    else
                                    {
                                        [Tool showCustomHUD:@"打卡成功" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                    }
                                    self.signInBtn.enabled = YES;
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"列表获取出错");
                                    self.signInBtn.enabled = YES;
                                    if ([UserModel Instance].isNetworkRunning == NO) {
                                        return;
                                    }
                                    if ([UserModel Instance].isNetworkRunning) {
                                        [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                    }
                                }];
}

@end
