//
//  Region.h
//  WHDLife
//
//  Created by Seven on 15-1-22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic, retain) NSString *regionId;
@property (nonatomic, retain) NSString *regionName;

@property (nonatomic, retain) NSArray *subList;
@property (nonatomic, retain) NSArray *buildingList;

@end
