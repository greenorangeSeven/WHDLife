//
//  FriendsPageView.h
//  WHDLife
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsPageView : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)reloadTopicByType:(int)type andTitle :(NSString *)title;
@end
