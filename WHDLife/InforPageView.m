//
//  InforPageView.m
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "InforPageView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "CommDetailView.h"
#import "OverviewFrameView.h"

@interface InforPageView ()
{
    UserInfo *userInfo;
}

@end

@implementation InforPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"资讯";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    userInfo = [[UserModel Instance] getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
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

//生活信息
- (IBAction)lifeInfoAction:(id)sender {
    NSString *lifeInfoHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_lifeInfoHtm ,AccessId];
    CommDetailView *lifeInfoView = [[CommDetailView alloc] init];
    lifeInfoView.titleStr = @"生活信息";
    lifeInfoView.urlStr = lifeInfoHtm;
    lifeInfoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lifeInfoView animated:YES];
}

//办事指南
- (IBAction)compassAction:(id)sender {
    NSString *workingManualHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_workingManual ,AccessId];
    CommDetailView *workingManualView = [[CommDetailView alloc] init];
    workingManualView.titleStr = @"办事指南";
    workingManualView.urlStr = workingManualHtm;
    workingManualView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workingManualView animated:YES];
}

//物业信息
- (IBAction)coninforAction:(id)sender {
    NSString *managerInfoHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_managerInfo ,userInfo.defaultUserHouse.cellId];
    CommDetailView *managerInfoView = [[CommDetailView alloc] init];
    managerInfoView.titleStr = @"物业信息";
    managerInfoView.urlStr = managerInfoHtm;
    managerInfoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:managerInfoView animated:YES];
}

//便民黄页
- (IBAction)almanacAction:(id)sender {
    NSString *yellowPageHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_yellowPage, AccessId];
    CommDetailView *yellowPageView = [[CommDetailView alloc] init];
    yellowPageView.titleStr = @"便民黄页";
    yellowPageView.urlStr = yellowPageHtm;
    yellowPageView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yellowPageView animated:YES];
}

- (IBAction)overviewAction:(id)sender {
    OverviewFrameView *overviewView = [[OverviewFrameView alloc] init];
    overviewView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:overviewView animated:YES];
}
@end
