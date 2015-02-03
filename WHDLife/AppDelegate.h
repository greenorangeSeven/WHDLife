//
//  AppDelegate.h
//  WHDLife
//
//  Created by Seven on 15-1-1.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "YRSideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL isForeground;
@property (copy, nonatomic) NSDictionary *pushInfo;

@property (strong,nonatomic) YRSideViewController *sideViewController;

@end

