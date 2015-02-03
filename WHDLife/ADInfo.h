//
//  ADInfo.h
//  BBK
//
//  Created by Seven on 14-12-9.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADInfo : NSObject

@property (nonatomic, retain) NSString *imgUrlFull;
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) NSString *adName;
@property (nonatomic, retain) NSString *url;
@property int expansionTypeId;   //0：通知（如果URL为空就是广告）     1:活动      2：商品
@property (nonatomic, retain) NSString *synopsis;

@end
