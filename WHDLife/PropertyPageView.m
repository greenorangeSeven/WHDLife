//
//  PropertyPageView.m
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "PropertyPageView.h"
#import "ActivityTableView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "CreateRepairView.h"
#import "NoticeTableView.h"
#import "CreateSuitView.h"
#import "PayFeeView.h"

@interface PropertyPageView ()

@end

@implementation PropertyPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"物业";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
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

//社区活动
- (IBAction)activityAction:(id)sender {
    ActivityTableView *activityView = [[ActivityTableView alloc] init];
    activityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityView animated:YES];
}

//房屋报修
- (IBAction)repairAction:(id)sender {
    CreateRepairView *createRepairView = [[CreateRepairView alloc] init];
    createRepairView.parentView = self.view;
    createRepairView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createRepairView animated:YES];
}

//物业通知
- (IBAction)noticeAction:(id)sender {
    NoticeTableView *noticeView = [[NoticeTableView alloc] init];
    noticeView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeView animated:YES];
}

//投诉建议
- (IBAction)suitAction:(id)sender {
    CreateSuitView *createSuitView = [[CreateSuitView alloc] init];
    createSuitView.parentView = self.view;
    createSuitView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createSuitView animated:YES];
}

//水电缴费
- (IBAction)payFeeAction:(id)sender {
    PayFeeView *payView = [[PayFeeView alloc] init];
    payView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payView animated:YES];
}

@end
