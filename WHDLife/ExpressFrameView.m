//
//  ExpressFrameView.m
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ExpressFrameView.h"

@interface ExpressFrameView ()

@end

@implementation ExpressFrameView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"快递及时通";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    if([self.present isEqualToString:@"present"] == YES)
    {
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle: @"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction)];
        leftBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    //下属控件初始化
    self.gatherView = [[GatherTableView alloc] init];
    self.gatherView.frameView = self.mainView;
    [self addChildViewController:self.gatherView];
    [self.mainView addSubview:self.gatherView.view];
}

- (void)closeAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)item1Action:(id)sender {
    [self.item1Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    self.gatherView.view.hidden = NO;
    self.sendView.view.hidden = YES;
    self.historyView.view.hidden = YES;
}

- (IBAction)item2Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    if (self.sendView == nil) {
        self.sendView = [[SendExpressView alloc] init];
        self.sendView.frameView = self.mainView;
        [self addChildViewController:self.sendView];
        [self.mainView addSubview:self.sendView.view];
    }
    self.gatherView.view.hidden = YES;
    self.sendView.view.hidden = NO;
    self.historyView.view.hidden = YES;
}

- (IBAction)item3Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    if (self.historyView == nil) {
        self.historyView = [[HistoryExpressView alloc] init];
        self.historyView.frameView = self.mainView;
        [self addChildViewController:self.historyView];
        [self.mainView addSubview:self.historyView.view];
    }
    self.gatherView.view.hidden = YES;
    self.sendView.view.hidden = YES;
    self.historyView.view.hidden = NO;
}

@end
