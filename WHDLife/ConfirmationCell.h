//
//  ConfirmationCell.h
//  WHDLife
//
//  Created by Seven on 15-1-20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *properyLb;
@property (weak, nonatomic) IBOutlet UITextField *numberTf;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
