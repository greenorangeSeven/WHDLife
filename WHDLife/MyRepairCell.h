//
//  MyRepairCell.h
//  WHDLife
//
//  Created by Seven on 15-1-9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRepairCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *repairWorkNumLb;
@property (weak, nonatomic) IBOutlet UILabel *repairStateLb;
@property (weak, nonatomic) IBOutlet UILabel *repairerLb;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end
