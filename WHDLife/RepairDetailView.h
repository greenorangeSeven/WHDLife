//
//  RepairDetailView.h
//  WHDLife
//
//  Created by Seven on 15-1-11.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (copy, nonatomic) NSString *present;
@property (copy, nonatomic) NSString *repairWorkId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

