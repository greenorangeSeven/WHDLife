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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
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
    self.scrollView.delegate=self;
    self.scrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*4, 0);
    for (int i=0; i<4; i++) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*KSCROLLVIEW_WIDTH, 0, KSCROLLVIEW_WIDTH, KSCROLLVIEW_HEIGHT)];
        CGRect frame = photoImageView.frame;
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
    LoginView *loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginView];
    AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdele.window.rootViewController = loginNav;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
