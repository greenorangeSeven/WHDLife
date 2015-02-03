//
//  FriendsReply.h
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 朋友圈回复
 */
@interface FriendsReply : NSObject

@property (nonatomic, copy) NSString *regUserName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *stateName;
@property (nonatomic, copy) NSString *replyTimeStamp;
@property (nonatomic, copy) NSString *photoFull;
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *regUserId;
@property (nonatomic, copy) NSString *replyTime;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *stateId;

@end
