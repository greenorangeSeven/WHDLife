//
//  ImgList.h
//  WHDLife
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgList : NSObject

@property (nonatomic ,copy) NSString *imgId;
@property (nonatomic ,copy) NSString *imgUrl;
@property (nonatomic ,copy) NSString *topicId;
@property (nonatomic ,copy) NSString *imgUrlFull;
@property (nonatomic, assign) int picWidth;
@property (nonatomic, assign) int picHeight;

@end
