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

- (void)bindData:(NSString *)imgUrl;
@end
