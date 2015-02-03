//
//  FriendsAddView.h
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsAddView : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *topicText;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopic;

- (void)reloadTopicByType:(int)type andTitle :(NSString *)title;
@end
