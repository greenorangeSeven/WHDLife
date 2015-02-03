//
//  FriendsDetailView.h
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsDetailView : UIViewController

@property (copy, nonatomic) NSString *topicId;
@property (weak, nonatomic) IBOutlet UIImageView *topicImg;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *my_avatar;
@property (weak, nonatomic) IBOutlet UITextField *comment_field;
@property (weak, nonatomic) IBOutlet UIButton *reply_Btn;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
- (IBAction)collectionAction:(id)sender;
- (IBAction)focusAction:(id)sender;

- (IBAction)pushReplyAction:(id)sender;

@end
