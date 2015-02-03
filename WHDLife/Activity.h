//
//  Activity.h
//  BBK
//
//  Created by Seven on 14-12-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, retain) NSString *activityName;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *qq;
@property (nonatomic, retain) NSString *starttime;
@property (nonatomic, retain) NSString *endtime;
@property (nonatomic, retain) NSString *cutoffTime;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *imgUrlFull;
@property (nonatomic, retain) NSString *contactMan;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *regUserId;

@property int userCount;//已报名人数
@property int totalCount;//允许报名人数

@property (nonatomic, retain) NSNumber *starttimeStamp;
@property (nonatomic, retain) NSNumber *endtimeStamp;
@property (nonatomic, retain) NSNumber *cutoffTimeStamp;

@property int stateId;
@property (nonatomic, retain) NSString *stateName;

@property (nonatomic, retain) NSString *isJoin;

@end
