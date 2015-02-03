//
//  OverviewFrameView.m
//  WHDLife
//
//  Created by Seven on 15-1-26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "OverviewFrameView.h"

@interface OverviewFrameView ()
{
    UserInfo *userInfo;
}

@end

@implementation OverviewFrameView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"小区概况";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    //下属控件初始化
    NSString *cellInfoHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_cellInfo ,userInfo.defaultUserHouse.cellId];
    self.xqjjView = [[CommDetailView alloc] init];
    self.xqjjView.frameView = self.mainView;
    self.xqjjView.titleStr = @"小区简介";
    self.xqjjView.urlStr = cellInfoHtm;
    [self addChildViewController:self.xqjjView];
    [self.mainView addSubview:self.xqjjView.view];
}

- (IBAction)xqjjAction:(id)sender
{
    [self.xqjjBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.xqjjBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    [self.xqdtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.xqdtBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    self.xqjjView.view.hidden = NO;
    self.xqdtView.view.hidden = YES;
}

- (IBAction)xqdtAction:(id)sender
{
    [self.xqjjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.xqjjBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.xqdtBtn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.xqdtBtn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    
    if (self.xqdtView == nil) {
        self.xqdtView = [[MapViewController alloc] init];
        self.xqdtView.frameView = self.mainView;
        [self addChildViewController:self.xqdtView];
        [self.mainView addSubview:self.xqdtView.view];
    }
    
    self.xqjjView.view.hidden = YES;
    self.xqdtView.view.hidden = NO;
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

@end
