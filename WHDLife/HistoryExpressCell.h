//
//  HistoryExpressCell.h
//  WHDLife
//
//  Created by Seven on 15-1-15.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryExpressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expressNumLb;
@property (weak, nonatomic) IBOutlet UILabel *expressStateLb;
@property (weak, nonatomic) IBOutlet UILabel *expressCompanyLb;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end
