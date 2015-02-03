//
//  ActivityCell.h
//  WHDLife
//
//  Created by Seven on 15-1-7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *cutoffTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *userCountLb;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end
