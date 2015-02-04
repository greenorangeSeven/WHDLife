//
//  StartView.m
//  DianLiangCity
//
//  Created by Seven on 14-9-29.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "StartView.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "MainTabView.h"
#import "LeftView.h"

@interface StartView ()
{
    UIImageView *_imageView;
    NSArray *_permissions;
    int GlobalPageControlNumber;
    
}

@end

@implementation StartView

#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define KSCROLLVIEW_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"设置";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.intoButton.hidden = YES;
    [self buildUI];
    [self createScrollView];
}

#pragma mark - privite method
#pragma mark
- (void)buildUI
{
    if (!IS_IPHONE_5) {
        _pageControl.frame = CGRectMake(_pageControl.frame.origin.x, _pageControl.frame.origin.y-88, _pageControl.frame.size.width, _pageControl.frame.size.height);
    }
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
}
#pragma mark createScrollView
-(void)createScrollView
{
    self.scrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*4, KSCROLLVIEW_HEIGHT);
    self.scrollView.delegate=self;
    for (int i=0; i<4; i++) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*KSCROLLVIEW_WIDTH, 0, KSCROLLVIEW_WIDTH, KSCROLLVIEW_HEIGHT)];
//        CGRect frame = photoImageView.frame;
        NSString *str = @"";
        if (IS_IPHONE_5) {
            str = [NSString stringWithFormat:@"v引导_%d",i+1];
        }
        else{
            str = [NSString stringWithFormat:@"v引导480_%d",i+1];
        }
        photoImageView.image=[UIImage imageNamed:str];
        [photoImageView setContentMode:UIViewContentModeTop];
        [self.scrollView addSubview:photoImageView];
    }
}

#pragma mark - scrollView delegate Method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.x >= KSCROLLVIEW_WIDTH*5) {
        scrollView.contentOffset = CGPointMake(KSCROLLVIEW_WIDTH*5, 0);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    GlobalPageControlNumber = scrollView.contentOffset.x/KSCROLLVIEW_WIDTH;
    _pageControl.currentPage=GlobalPageControlNumber;
    if (GlobalPageControlNumber == 3)
    {
        self.intoButton.hidden = NO;
    }
    else
    {
        self.intoButton.hidden = YES;
    }
}

- (IBAction)enterAction:(id)sender
{
    if (self.isPush) {
        AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        MainTabView *mainViewController=[[MainTabView alloc]initWithNibName:@"MainTabView" bundle:nil];
        
        LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
        
        appdele.sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
        appdele.sideViewController.rootViewController=mainViewController;
        appdele.sideViewController.leftViewController=leftViewController;
        
        appdele.sideViewController.leftViewShowWidth=200;
        appdele.sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
        
        appdele.window.rootViewController = appdele.sideViewController;
    }
    else
    {
        LoginView *loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginView];
        AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdele.window.rootViewController = loginNav;
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
