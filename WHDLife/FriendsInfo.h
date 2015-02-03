//
//  FriendsInfo.h
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 朋友圈详情
 */
@interface FriendsInfo : NSObject

@property (nonatomic ,copy) NSString *topicId;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *stateId;
@property (nonatomic ,copy) NSString *cellId;
@property (nonatomic ,copy) NSString *regUserId;
@property (nonatomic ,copy) NSString *typeId;

@property (nonatomic ,copy) NSString *typeName;

@property (nonatomic ,copy) NSString *stateName;

@property (nonatomic ,copy) NSString *regUserName;

@property (nonatomic ,copy) NSString *nickName;

@property (nonatomic ,copy) NSString *cellName;

@property (nonatomic ,copy) NSString *photoFull;

@property (nonatomic ,copy) NSString *starttimeStamp;

@property (nonatomic ,copy) NSString *starttime;

@property (nonatomic, strong) NSMutableArray *imgList;
@property (nonatomic, strong) NSMutableArray *imgUrlList;
@property (nonatomic, strong) NSMutableArray *replyList;

@property int isHeart;
@property int isAttention;
@property int isReply;

@property int replyCount;
@property int heartCount;
@property int attentionCount;

@property int contentHeight;
@end
