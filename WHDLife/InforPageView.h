//
//  InforPageView.h
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InforPageView : UIViewController

@property bool isVisitor;

//生活信息
- (IBAction)lifeInfoAction:(id)sender;
//办事指南
- (IBAction)compassAction:(id)sender;
//物业信息
- (IBAction)coninforAction:(id)sender;
//便民黄页
- (IBAction)almanacAction:(id)sender;
//小区概况
- (IBAction)overviewAction:(id)sender;

@end
