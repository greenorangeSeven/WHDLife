//
//  ExpressInfo.h
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressInfo : NSObject

@property (nonatomic, retain) NSString *expressId;
@property (nonatomic, retain) NSString *expressOrder;
@property (nonatomic, retain) NSString *expressCompanyId;
@property (nonatomic, retain) NSString *expressCompanyName;
@property int expressTypeId;
@property int stateId;
@property (nonatomic, retain) NSString *stateName;
@property (nonatomic, retain) NSString *receivesTypeName;
@property (nonatomic, retain) NSNumber *receiveTimeStamp;
@property (nonatomic, retain) NSNumber *arrivalTimeStamp;
@property (nonatomic, retain) NSNumber *starttimeStamp;

@property int isEvaluation;
@property int inOrOut;

@property BOOL isChecked;

@end
