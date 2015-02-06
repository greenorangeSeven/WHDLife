//
//  DiscoveryPageView.m
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "DiscoveryPageView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "ExpressFrameView.h"
#import "CommodityClassView.h"
#import "CommDetailView.h"
#import "ErrorView.h"

@interface DiscoveryPageView ()

@end

@implementation DiscoveryPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"发现";
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

//快递及时通
- (IBAction)expressAction:(id)sender {
    ExpressFrameView *expressView = [[ExpressFrameView alloc] init];
    expressView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:expressView animated:YES];
}

//精品推送
- (IBAction)commodityAction:(id)sender {
    CommodityClassView *commodityView = [[CommodityClassView alloc] init];
    commodityView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityView animated:YES];
}

//团购信息
- (IBAction)tuanAction:(id)sender {
//    NSString *detailHtm = @"http://i.meituan.com/?city=wuhan";
//    CommDetailView *detailView = [[CommDetailView alloc] init];
//    detailView.titleStr = @"团购信息";
//    detailView.urlStr = detailHtm;
//    detailView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailView animated:YES];
    //封板保留
    ErrorView *errorView = [[ErrorView alloc] init];
    errorView.titleStr = @"团购信息";
    errorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:errorView animated:YES];
}

//房屋租售
- (IBAction)fwzsAction:(id)sender {
//    NSString *detailHtm = @"http://m.anjuke.com/wh/";
//    CommDetailView *detailView = [[CommDetailView alloc] init];
//    detailView.titleStr = @"房屋租售";
//    detailView.urlStr = detailHtm;
//    detailView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailView animated:YES];
    //封板保留
    ErrorView *errorView = [[ErrorView alloc] init];
    errorView.titleStr = @"房屋租售";
    errorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:errorView animated:YES];
}

//装饰装修
- (IBAction)zszxAction:(id)sender {
//    NSString *detailHtm = @"http://www.whjzw.net/m/";
//    CommDetailView *detailView = [[CommDetailView alloc] init];
//    detailView.titleStr = @"装饰装修";
//    detailView.urlStr = detailHtm;
//    detailView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailView animated:YES];
    //封板保留
    ErrorView *errorView = [[ErrorView alloc] init];
    errorView.titleStr = @"装饰装修";
    errorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:errorView animated:YES];
}
@end
