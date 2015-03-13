//
//  FriendsImgCell.h
//  WHDLife
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsImgCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *tag_bg;
@property UIImageView *tagImg;
@property UILabel *contentLabel;

- (void)bindData:(NSString *)imgUrl typeIdIs:(int)typeId imgHeight:(CGFloat)imgHeight text:(NSString *)content;
@end
