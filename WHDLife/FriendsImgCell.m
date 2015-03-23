//
//  FriendsImgCell.m
//  WHDLife
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsImgCell.h"

@implementation FriendsImgCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FriendsImgCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)bindData:(NSString *)imgUrl typeIdIs:(int)typeId imgHeight:(CGFloat)imgHeight text:(NSString *)content
{
    if(_contentLabel)
        [_contentLabel removeFromSuperview];
    
    switch (typeId) {
        case 0:
//            [self.tagImg sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"friends_item_tag_share"]];
            [self.tagImg setImage:[UIImage imageNamed:@"friends_item_tag_share"]];
            break;
        case 1:
            [self.tagImg setImage:[UIImage imageNamed:@"friends_item_tag_help"]];
            break;
        case 2:
            [self.tagImg setImage:[UIImage imageNamed:@"friends_item_tag_tiaosao"]];
            break;
        case 3:
            [self.tagImg setImage:[UIImage imageNamed:@"friends_item_tag_tucao"]];
            break;
        case 4:
            [self.tagImg setImage:[UIImage imageNamed:@"friends_item_tag_zhaocha"]];
            
            break;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    self.imgView.frame = CGRectMake(self.imgView.frame.origin.x, self.imgView.frame.origin.y, self.frame.size.width, imgHeight);
    CGRect frame = CGRectMake(10, self.imgView.frame.size.height + 8, self.frame.size.width - 20, 20);
    _contentLabel = [[UILabel alloc] initWithFrame:frame];
    _contentLabel.font = [UIFont systemFontOfSize:11];
    _contentLabel.textColor = [UIColor colorWithRed:140/255 green:133/255 blue:126/255 alpha:1];
    _contentLabel.numberOfLines = 1;
    _contentLabel.text = content;
    [self addSubview:_contentLabel];
}

- (void)prepareForReuse
{
    NSLog(@"reused");
}
@end
