//
//  FriendsReplyCell.m
//  WHDLife
//
//  Created by mac on 15/1/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsReplyCell.h"

@implementation FriendsReplyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FriendsReplyCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
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
    //图片圆形处理
    self.avatar.layer.masksToBounds=YES;
    self.avatar.layer.cornerRadius=self.avatar.frame.size.width/2;//最重要的是这个地方要设成imgview高的一半
}

- (void)bindData:(FriendsReply *)reply
{
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:reply.photoFull] placeholderImage:[UIImage imageNamed:@"userface.png"]];
    NSString *nickname = @"匿名用户";
    if(reply.nickName.length > 0)
    {
        nickname = reply.nickName;
    }
    else if(reply.regUserName.length > 0)
    {
        nickname = reply.regUserName;
    }
    self.nickname.text = nickname;
    self.content.text = reply.replyContent;
    self.time.text = [Tool intervalSinceNow:[Tool TimestampToDateStr:reply.replyTimeStamp andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
