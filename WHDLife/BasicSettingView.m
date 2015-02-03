//
//  BasicSettingView.m
//  WHDLife
//
//  Created by Seven on 15-1-15.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "BasicSettingView.h"
#import "SDImageCache.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

@interface BasicSettingView ()

@end

@implementation BasicSettingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"设置";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    [Tool roundTextView:self.settingView andBorderWidth:1.0 andCornerRadius:5];
    [Tool roundTextView:self.clearCacheBtn andBorderWidth:1.0 andCornerRadius:5];
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理图片缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理图片缓存(%.2fK)",tmpSize * 1024];
    [self.clearCacheBtn setTitle:clearCacheName forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController setNeedSwipeShowMenu:NO];
    
    BOOL isPushOn = NO;
    
    if(IS_IOS8){
        isPushOn = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
    }
    else
    {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            isPushOn = NO;
        }
        else
        {
            isPushOn = YES;
        }
    }
    if (isPushOn) {
        self.pushLb.text = @"已开启";
        self.pushLb.textColor = [Tool getColorForMain];
    }
    else
    {
        self.pushLb.text = @"已关闭";
        self.pushLb.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    }
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

- (IBAction)clearCacheAction:(id)sender {
    [[SDImageCache sharedImageCache] clearDisk];
    [Tool showCustomHUD:@"清理中..." andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
}
@end
