//
//  MainTabView.m
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MainTabView.h"
#import "MainPageView.h"
#import "InforPageView.h"
#import "PropertyPageView.h"
#import "DiscoveryPageView.h"
#import "FriendsPageView.h"

@interface MainTabView ()
{
    UITabBarController *_tabC;
}

@end

@implementation MainTabView

static MainTabView *main;

+ (MainTabView *)getMain
{
    return main;
}

- (id)init
{
    self = [super init];
    
    main = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabC = [[UITabBarController alloc] init];
    [_tabC.tabBar setBackgroundColor:[UIColor clearColor]];
    [_tabC.view setFrame:self.view.frame];
    [self.view addSubview:_tabC.view];
    
    MainPageView* mainPage = [[MainPageView alloc] init];
    mainPage.tabBarItem.image = [UIImage imageNamed:@"bar_main"];
    mainPage.tabBarItem.title = @"首页";
    self.mainPageNav = [[UINavigationController alloc] initWithRootViewController:mainPage];
    
    InforPageView *inforPage = [[InforPageView alloc] init];
    inforPage.tabBarItem.image = [UIImage imageNamed:@"bar_infor"];
    inforPage.tabBarItem.title = @"资讯";
    UINavigationController *inforPageNav = [[UINavigationController alloc] initWithRootViewController:inforPage];
    
    PropertyPageView *proPage = [[PropertyPageView alloc] init];
    proPage.tabBarItem.image = [UIImage imageNamed:@"bar_realestate"];
    proPage.tabBarItem.title = @"物业";
    UINavigationController *proPageNav = [[UINavigationController alloc] initWithRootViewController:proPage];
    
    DiscoveryPageView *discoveryPage = [[DiscoveryPageView alloc] init];
    discoveryPage.tabBarItem.image = [UIImage imageNamed:@"bar_discovery"];
    discoveryPage.tabBarItem.title = @"发现";
    UINavigationController *discoveryPageNav = [[UINavigationController alloc] initWithRootViewController:discoveryPage];
    FriendsPageView *friendsPage = [[FriendsPageView alloc] init];
    friendsPage.tabBarItem.image = [UIImage imageNamed:@"bar_circle"];
    friendsPage.tabBarItem.title = @"朋友圈";
    UINavigationController *friendsPageNav = [[UINavigationController alloc] initWithRootViewController:friendsPage];
    _tabC.viewControllers = @[self.mainPageNav, inforPageNav, proPageNav, discoveryPageNav,friendsPageNav];
    [[_tabC tabBar] setSelectedImageTintColor:[Tool getColorForMain]];

}

- (void)reloadImage
{
    NSArray *ar = _tabC.viewControllers;
    NSMutableArray *arD = [NSMutableArray new];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
     {
         //        UITabBarItem *item = viewController.tabBarItem;
         UITabBarItem *item = nil;
         switch (idx)
         {
             case 0:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"bar_main.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"bar_main.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                 break;
             }
             case 1:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"资讯" image:nil tag:1];
                 [item setImage:[[UIImage imageNamed:@"bar_infor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                 [item setSelectedImage:[[UIImage imageNamed:@"bar_infor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                 break;
             }
             case 2:
             {
                 item = [[UITabBarItem alloc]initWithTitle:@"动态" image:nil tag:1];
                 [item setImage:[[UIImage imageNamed:@"tab_qworld_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                 [item setSelectedImage:[[UIImage imageNamed:@"tab_qworld_press.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                 break;
             }
         }
         viewController.tabBarItem = item;
         [arD addObject:viewController];
     }];
    _tabC.viewControllers = arD;
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
