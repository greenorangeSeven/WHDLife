//
//  FriendsMyPublishCell.h
//  WHDLife
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsMyPublishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgInfo;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;

- (void)bindData:(NSString *)imgUrl andType : (int)type;
@end
