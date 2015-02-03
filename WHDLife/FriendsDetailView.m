//
//  FriendsDetailView.m
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsDetailView.h"
#import "FriendsReplyCell.h"
#import "FriendsOtherView.h"

@interface FriendsDetailView ()<UITableViewDataSource,UITableViewDelegate>
{
    FriendsInfo *friendsInfo;
    UserInfo *userInfo;
    MBProgressHUD *hud;
}

@end

@implementation FriendsDetailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    userInfo = [[UserModel Instance] getUserInfo];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"详情";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    //图片圆形处理
    self.avatar.layer.masksToBounds=YES;
    self.avatar.layer.cornerRadius=self.avatar.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    //图片圆形处理
    self.my_avatar.layer.masksToBounds=YES;
    self.my_avatar.layer.cornerRadius=self.my_avatar.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool roundTextView:self.reply_Btn andBorderWidth:1.0f andCornerRadius:5.0f];
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    self.commentTableView.contentSize = CGSizeMake(self.commentTableView.frame.size.width, self.commentTableView.frame.size.height + 90);
    //    设置无分割线
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark 获取帖子详情
- (void)loadData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        if(!hud.hidden)
            hud.hidden = NO;
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        //生成获取活动列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.topicId forKey:@"topicId"];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        
        NSString *getTopicUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findTopicInfoById] params:param];
        
        [[AFOSCClient sharedClient]getPath:getTopicUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       hud.hidden = YES;
                                       friendsInfo = [Tool readJsonStrToFriendsInfo:operation.responseString];
                                       if(friendsInfo)
                                           [self bindData];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
    }
}

- (void)goFriendsOther:(id)sender
{
    FriendsOtherView *otherView = [[FriendsOtherView alloc] init];
    otherView.userId = friendsInfo.regUserId;
    NSString *nickname = @"匿名用户";
    if (friendsInfo.nickName != nil && [friendsInfo.nickName isEqualToString:@""] == NO)
    {
        nickname = friendsInfo.nickName;
    }
    else if (friendsInfo.regUserName != nil && [friendsInfo.regUserName isEqualToString:@""] == NO)
    {
        nickname = friendsInfo.regUserName;
    }
    otherView.nickname = nickname;
    otherView.photoFull = friendsInfo.photoFull;
    [self.navigationController pushViewController:otherView animated:YES];
}

- (void)bindData
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goFriendsOther:)];
    [self.avatar addGestureRecognizer:recognizer];
    [self.topicImg sd_setImageWithURL:[NSURL URLWithString:friendsInfo.imgUrlList[0]] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    self.contentLabel.text = friendsInfo.content;
    //时间
    self.timeLabel.text = [Tool intervalSinceNow:[Tool TimestampToDateStr:friendsInfo.starttimeStamp andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
    NSString *nickname = @"匿名用户";
    if (friendsInfo.nickName != nil && [friendsInfo.nickName isEqualToString:@""] == NO)
    {
        nickname = friendsInfo.nickName;
    }
    else if (friendsInfo.regUserName != nil && [friendsInfo.regUserName isEqualToString:@""] == NO)
    {
        nickname = friendsInfo.regUserName;
    }
    //昵称
    self.nickNameLabel.text = nickname;
    if(friendsInfo.photoFull.length > 0)
    {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:friendsInfo.photoFull] placeholderImage:[UIImage imageNamed:@"userface.png"]];
    }
    
    [self.my_avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"userface.png"]];
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评论%i",friendsInfo.replyCount] forState:UIControlStateNormal];
    if(friendsInfo.isReply)
    {
        [self.commentBtn setImage:[UIImage imageNamed:@"friends_detail_comsize_press"] forState:UIControlStateNormal];
    }
    
    [self.collectionBtn setTitle:[NSString stringWithFormat:@"收藏%i",friendsInfo.heartCount] forState:UIControlStateNormal];
    if(friendsInfo.isHeart)
    {
        [self.commentBtn setImage:[UIImage imageNamed:@"friends_detail_collecsize"] forState:UIControlStateNormal];
    }
    
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"关注%i",friendsInfo.attentionCount] forState:UIControlStateNormal];
    if(friendsInfo.isAttention)
    {
        [self.attentionBtn setImage:[UIImage imageNamed:@"friends_detail_focus_press"] forState:UIControlStateNormal];
    }
    [self.commentTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(friendsInfo.replyList && friendsInfo.replyList.count > 0)
    {
        return friendsInfo.replyList.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(friendsInfo.replyList && friendsInfo.replyList.count > 0) {
        FriendsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsReplyCell"];
        if (!cell)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FriendsReplyCell" owner:nil options:nil];
            for (NSObject *o in objects)
            {
                if ([o isKindOfClass:[FriendsReplyCell class]])
                {
                    cell = (FriendsReplyCell *)o;
                    break;
                }
            }
        }
        
        FriendsReply *reply = friendsInfo.replyList[indexPath.row];
        [cell bindData:reply];
        
        return cell;
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:NO andLoadOverString:@"暂无评论" andLoadingString:@"暂无评论" andIsLoading:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 收藏帖子
- (IBAction)collectionAction:(id)sender
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:friendsInfo.topicId forKey:@"topicId"];
    NSString *createSign = nil;
    //生成创建帖子URL
    NSString *createUrl = nil;
    if(friendsInfo.isHeart == 1)
    {
        createSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicHeart] params:param];
        createUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicHeart];
    }
    else
    {
        createSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicHeart] params:param];
        createUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicHeart];
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:friendsInfo.topicId forKey:@"topicId"];
    [request setDelegate:self];
    request.tag = 3;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"请稍后..." andView:self.view andHUD:request.hud];
}

#pragma mark 关注用户
- (IBAction)focusAction:(id)sender
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:friendsInfo.regUserId forKey:@"mainRegUserId"];
    NSString *createSign = nil;
    //生成创建帖子URL
    NSString *createUrl = nil;
    if(friendsInfo.isAttention == 1)
    {
        createSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicAttnetion] params:param];
        createUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicAttnetion];
    }
    else
    {
        createSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicAttnetion] params:param];
        createUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicAttnetion];
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:friendsInfo.regUserId forKey:@"mainRegUserId"];
    [request setDelegate:self];
    request.tag = 2;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"请稍后..." andView:self.view andHUD:request.hud];
    
}

#pragma mark 回复帖子
- (IBAction)pushReplyAction:(id)sender
{
    if(friendsInfo.isReply)
    {
        [Tool showCustomHUD:@"您已评论过该贴" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    NSString *commentStr = self.comment_field.text;
    if ([commentStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入评论内容" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:friendsInfo.topicId forKey:@"topicId"];
    [param setValue:commentStr forKey:@"replyContent"];
    NSString *createSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicReply] params:param];
    
    //生成创建帖子URL
    NSString *createUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicReply];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:friendsInfo.topicId forKey:@"topicId"];
    [request setPostValue:commentStr forKey:@"replyContent"];
    [request setDelegate:self];
    request.tag = 1;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"提交中..." andView:self.view andHUD:request.hud];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
}

- (void)requestCreate:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:[[json objectForKey:@"header"] objectForKey:@"msg"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    else
    {
        //判断是否为帖子回复
        if(request.tag == 1)
        {
            self.comment_field.text = @"";
            [Tool showCustomHUD:@"已回复" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
            FriendsReply *reply = [RMMapper objectWithClass:[FriendsReply class] fromDictionary:[json objectForKey:@"data"]];
            [friendsInfo.replyList insertObject:reply atIndex:0];
            friendsInfo.isReply = 1;
            ++friendsInfo.replyCount;
            [self.commentBtn setTitle:[NSString stringWithFormat:@"评论%i",friendsInfo.replyCount] forState:UIControlStateNormal];
            [self.commentBtn setImage:[UIImage imageNamed:@"friends_detail_comsize_press"] forState:UIControlStateNormal];
            
            [self.commentTableView reloadData];
        }
        //判断是否为关注
        else if(request.tag == 2)
        {
            if(friendsInfo.isAttention)
            {
                friendsInfo.isAttention = 0;
                --friendsInfo.attentionCount;
                [self.attentionBtn setTitle:[NSString stringWithFormat:@"关注%i",friendsInfo.attentionCount] forState:UIControlStateNormal];
                [Tool showCustomHUD:@"已取消关注" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
                [self.attentionBtn setImage:[UIImage imageNamed:@"friends_detail_focus"] forState:UIControlStateNormal];
            }
            else
            {
                friendsInfo.isAttention = 1;
                ++friendsInfo.attentionCount;
                [self.attentionBtn setTitle:[NSString stringWithFormat:@"关注%i",friendsInfo.attentionCount] forState:UIControlStateNormal];
                [Tool showCustomHUD:@"已关注" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
                [self.attentionBtn setImage:[UIImage imageNamed:@"friends_detail_focus_press"] forState:UIControlStateNormal];
            }
        }
        
        //判断是否为收藏
        else if(request.tag == 3)
        {
            if(friendsInfo.isHeart)
            {
                friendsInfo.isHeart = 0;
                --friendsInfo.heartCount;
                [self.collectionBtn setTitle:[NSString stringWithFormat:@"收藏%i",friendsInfo.heartCount] forState:UIControlStateNormal];
                [Tool showCustomHUD:@"已取消收藏" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
                [self.collectionBtn setImage:[UIImage imageNamed:@"friends_detail_collecsize_normal"] forState:UIControlStateNormal];
            }
            else
            {
                friendsInfo.isHeart = 1;
                ++friendsInfo.heartCount;
                [self.collectionBtn setTitle:[NSString stringWithFormat:@"收藏%i",friendsInfo.heartCount] forState:UIControlStateNormal];
                [Tool showCustomHUD:@"已收藏" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
                [self.collectionBtn setImage:[UIImage imageNamed:@"friends_detail_collecsize"] forState:UIControlStateNormal];
            }
        }
        
    }
}
@end
