//
//  MainTabView.h
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageView.h"

@interface MainTabView : UIViewController

+ (MainTabView *)getMain;

@property (strong,nonatomic) UINavigationController *mainPageNav;

@end
