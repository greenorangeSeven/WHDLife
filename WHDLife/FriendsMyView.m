//
//  ActivityTableView.m
//  WHDLife
//
//  Created by Seven on 15-1-7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsMyView.h"
#import "UIImageView+WebCache.h"
#import "FriendsMyPublishCell.h"
#import "FriendsFocusCell.h"
#import "FriendsAddView.h"
#import "FriendsDetailView.h"

@interface FriendsMyView ()
{
    UserInfo *userInfo;
    NSMutableArray *friendsList;
    //当前显示的类型
    //1,2:表示当前显示我的发布和我的关注,3,4:表示当前显示我的收藏和我的评论
    int type;
}

@end

@implementation FriendsMyView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    type = 1;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"我的圈子";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 19)];
    [rBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"activity_add"] forState:UIControlStateNormal];
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    
    //图片圆形处理
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius=self.faceIv.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    
    //设置头像
    userInfo = [[UserModel Instance] getUserInfo];
    if(userInfo.photoFull.length > 0)
    {
        [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"userface.png"]];
    }
    
    NSString *nickname = @"匿名用户";
    if (userInfo.nickName != nil && [userInfo.nickName isEqualToString:@""] == NO)
    {
        nickname = userInfo.nickName;
    }
    else if (userInfo.regUserName != nil && [userInfo.regUserName isEqualToString:@""] == NO)
    {
        nickname = userInfo.regUserName;
    }
    
    self.nickName.text = nickname;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    friendsList = [[NSMutableArray alloc] initWithCapacity:20];
    
    userInfo = [[UserModel Instance] getUserInfo];
    //    [self getADVData];
    [self reload:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyFriends) name:@"updateMyFriends" object:nil];
}

- (void)updateMyFriends
{
    isLoadOver = NO;
    [self reload:NO];
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

- (void)addAction:(id *)sender
{
    FriendsAddView *addView = [[FriendsAddView alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [friendsList removeAllObjects];
    friendsList = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [friendsList removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver)
        {
            return;
        }
        if (!noRefresh)
        {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        
        //生成获取活动列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"0" forKey:@"stateId"];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        [param setValue:@"20" forKey:@"countPerPages"];
        
        NSString *tempUrl = nil;
        if(type == 1)
            tempUrl = api_findTopicInfoByPage;
        else if(type == 2)
            tempUrl = api_findTopicInfoByAttention;
        else if(type == 3)
            tempUrl = api_findTopicInfoByReply;
        else if(type == 4)
            tempUrl = api_findTopicInfoByHeart;
        
        NSString *getTopicUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, tempUrl] params:param];
        
        [[AFOSCClient sharedClient]getPath:getTopicUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       friendsList = [Tool readJsonStrToFriendsArray:operation.responseString];
                                       @try {
                                           int count = [friendsList count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           if(type == 1)
                                           {
                                               self.topicCount.text = [NSString stringWithFormat:@"共%i个瞬间",count];
                                           }
                                           [self.tableView reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        isLoading = YES;
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return friendsList.count == 0 ? 1 : friendsList.count;
        }
        else
            return friendsList.count + 1;
    }
    else
        return friendsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(type == 1 || type == 2)
        return 137;
    else
    {
        if (indexPath.row < friendsList.count)
        {
            FriendsList *cate = [friendsList objectAtIndex:[indexPath row]];
            int height = 140 + cate.contentHeight - 43;
            if ([cate.imgList count] == 0)
            {
                height -= 63;
            }
            else
            {
                int size = cate.imgList.count / 3;
                if(cate.imgList.count % 3 == 0)
                {
                    size -= 1;
                }
                if(size < 1)
                    size = 0;
                
                int thumbExtraHeight = size * 63;
                height += thumbExtraHeight;
            }
            return height;
        }
        else
        {
            return 62;
        }
    }
    //    return 62;
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if ([friendsList count] > 0) {
        if (row < [friendsList count])
        {
            if(type == 1 || type == 2)
            {
                FriendsMyPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsMyPublishCell"];
                if (!cell)
                {
                    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FriendsMyPublishCell" owner:self options:nil];
                    for (NSObject *o in objects)
                    {
                        if ([o isKindOfClass:[FriendsMyPublishCell class]])
                        {
                            cell = (FriendsMyPublishCell *)o;
                            break;
                        }
                    }
                }
                
                FriendsList *friends = [friendsList objectAtIndex:row];
                NSString *imgUrl = friends.imgUrlList[0];
                [cell bindData:imgUrl andType:1];
                return cell;
            }
            else
            {
                FriendsFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsFocusCell"];
                if (!cell)
                {
                    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FriendsFocusCell" owner:nil options:nil];
                    for (NSObject *o in objects)
                    {
                        if ([o isKindOfClass:[FriendsFocusCell class]])
                        {
                            cell = (FriendsFocusCell *)o;
                            break;
                        }
                    }
                }
                
                FriendsList *cate = [friendsList objectAtIndex:[indexPath row]];
                cell.navigationController = self.navigationController;
                
                //内容
                cell.contentLb.text = cate.content;
                CGRect contentLb = cell.contentLb.frame;
                cell.contentLb.frame = CGRectMake(contentLb.origin.x, contentLb.origin.y, contentLb.size.width, cate.contentHeight -10);
                if ([cate.imgUrlList count] > 0)
                {
                    cell.imgCollectionView.hidden = NO;
                    double size = cate.imgUrlList.count / 3;
                    if(cate.imgUrlList.count % 3 == 0)
                    {
                        size -= 1;
                    }
                    if(size < 1)
                        size = 0;
                    int thumbHeight = 62;
                    thumbHeight += size * 62;
                    cell.imgCollectionView.frame = CGRectMake(cell.imgCollectionView.frame.origin.x, cell.contentLb.frame.origin.y + cell.contentLb.frame.size.height, cell.imgCollectionView.frame.size.width, thumbHeight);
                    
                    cell.imgArray = cate.imgUrlList;
                    [cell.imgCollectionView reloadData];
                    //重新设置分割线位置
                    cell.bottom_line.frame = CGRectMake(cell.bottom_line.frame.origin.x, cell.imgCollectionView.frame.origin.y + cell.imgCollectionView.frame.size.height + 3, cell.bottom_line.frame.size.width, cell.bottom_line.frame.size.height);
                }
                else
                {
                    cell.imgCollectionView.hidden = YES;
                    cell.bottom_line.frame = CGRectMake(cell.bottom_line.frame.origin.x, cell.imgCollectionView.frame.origin.y + 3, cell.bottom_line.frame.size.width, cell.bottom_line.frame.size.height);
                }
                
                //时间
                cell.timeLb.text = [Tool intervalSinceNow:[Tool TimestampToDateStr:cate.starttimeStamp andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];;
                NSString *nickname = @"匿名用户";
                if (cate.nickName != nil && [cate.nickName isEqualToString:@""] == NO)
                {
                    nickname = cate.nickName;
                }
                else if (cate.regUserName != nil && [cate.regUserName isEqualToString:@""] == NO)
                {
                    nickname = cate.regUserName;
                }
                //昵称
                cell.nickNameLb.text = nickname;
                if(cate.photoFull.length > 0)
                {
                    [cell.facePic sd_setImageWithURL:[NSURL URLWithString:cate.photoFull] placeholderImage:[UIImage imageNamed:@"userface.png"]];
                }
                
                return cell;
            }
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    if (row >= [friendsList count]) {
        return;
    }
    else
    {
        FriendsList *fri = friendsList[indexPath.row];
        FriendsDetailView *detailView = [[FriendsDetailView alloc] init];
        detailView.topicId = fri.topicId;
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading) {
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)dealloc
{
    [self.tableView setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)item1Action:(id)sender {
    [self.item1Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item4btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item4btn setBackgroundImage:nil forState:UIControlStateNormal];
    isLoadOver = NO;
    type = 1;
    [self reload:NO];
}

- (IBAction)item2Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item4btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item4btn setBackgroundImage:nil forState:UIControlStateNormal];
    isLoadOver = NO;
    type = 2;
    [self reload:NO];
}

- (IBAction)item3Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item4btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item4btn setBackgroundImage:nil forState:UIControlStateNormal];
    isLoadOver = NO;
    type = 3;
    [self reload:NO];
}

- (IBAction)item4Action:(id)sender
{
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.item4btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item4btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    isLoadOver = NO;
    type = 4;
    [self reload:NO];
}

@end
