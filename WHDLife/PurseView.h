//
//  PurseView.h
//  WHDLife
//
//  Created by Seven on 15-1-23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurseView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UIView *frameView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
