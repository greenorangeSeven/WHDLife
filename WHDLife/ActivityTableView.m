//
//  ActivityTableView.m
//  WHDLife
//
//  Created by Seven on 15-1-7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ActivityTableView.h"
#import "ActivityCell.h"
#import "UIImageView+WebCache.h"
#import "ActivityInitiateView.h"
#import "ActivityDetailView.h"

@interface ActivityTableView ()
{
    UserInfo *userInfo;
    //myInitiate我发起的   myJoin我参与的
    NSString *findType;
}

@end

@implementation ActivityTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"社区活动";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 19)];
    [rBtn addTarget:self action:@selector(initiateAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"activity_add"] forState:UIControlStateNormal];
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    activitys = [[NSMutableArray alloc] initWithCapacity:20];
    
    userInfo = [[UserModel Instance] getUserInfo];
    //    [self getADVData];
    [self reload:YES];
}

- (void)initiateAction:(id *)sender
{
    ActivityInitiateView *initiateView = [[ActivityInitiateView alloc] init];
    initiateView.parentView = self.view;
    [self.navigationController pushViewController:initiateView animated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [activitys removeAllObjects];
    activitys = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [activitys removeAllObjects];
    isLoadOver = NO;
}

- (void)initTopActivity
{
    int length = [advDatas count];
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1)
    {
        Activity *activity = [advDatas objectAtIndex:length-1];
        
        NSString *title = [NSString stringWithFormat:@"  %@\n", activity.activityName];
        NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
        [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [activity.activityName length] + 2)];
        
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:activity.imgUrlFull tag:length-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        Activity *activity = [advDatas objectAtIndex:i];
        
        NSString *title = [NSString stringWithFormat:@"  %@\n", activity.activityName];
        NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
        [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [activity.activityName length] + 2)];
        
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:activity.imgUrlFull tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        Activity *activity = [advDatas objectAtIndex:0];
        
        NSString *title = [NSString stringWithFormat:@"  %@\n", activity.activityName];
        NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
        [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [activity.activityName length] + 2)];
        
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:activity.imgUrlFull tag:0];
        [itemArray addObject:item];
    }
    bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 140) delegate:self imageItems:itemArray isAuto:YES];
    [bannerView scrollToIndex:0];
    [self.advIv addSubview:bannerView];
}

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    Activity *activity = (Activity *)[advDatas objectAtIndex:advIndex];
    if (activity)
    {
        ActivityDetailView *detailView = [[ActivityDetailView alloc] init];
        detailView.activityId = activity.activityId;
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    advIndex = index;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        
        //生成获取活动列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"20" forKey:@"countPerPages"];
        //我参与的
        if([findType isEqualToString:@"myJoin"] == YES)
        {
            [param setValue:userInfo.regUserId forKey:@"joinUserId"];
        }
        else if ([findType isEqualToString:@"myInitiate"] == YES)
        {
            [param setValue:userInfo.regUserId forKey:@"regUserId"];
        }
        NSString *getNoticeListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCellActivityByPage] params:param];
        
        [[AFOSCClient sharedClient]getPath:getNoticeListUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSMutableArray *activityNews = [Tool readJsonStrToActivityArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           int count = [activityNews count];
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [activitys addObjectsFromArray:activityNews];
                                           [self.tableView reloadData];
                                           [self doneLoadingTableViewData];
                                           
                                           if (noRefresh) {
                                               if ([activitys count] > 0) {
                                                   if ([activitys count] < 3) {
                                                       advDatas = activitys;
                                                   }
                                                   else
                                                   {
                                                       advDatas = [activitys subarrayWithRange:NSMakeRange(0, 3)];
                                                   }
                                                   [self initTopActivity];
                                               }
                                           }
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
            return activitys.count == 0 ? 1 : activitys.count;
        }
        else
            return activitys.count + 1;
    }
    else
        return activitys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (row < activitys.count)
    {
        return 78.0;
    }
    else
    {
        return 40.0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if ([activitys count] > 0) {
        if (row < [activitys count])
        {
            
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[ActivityCell class]]) {
                        cell = (ActivityCell *)o;
                        break;
                    }
                }
            }
            Activity *activity = [activitys objectAtIndex:row];
            
            [cell.imageIv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_200", activity.imgUrlFull]] placeholderImage:[UIImage imageNamed:@"loadingpic.png"]];
            [cell.stateBtn setTitle:activity.stateName forState:UIControlStateDisabled];
            [cell.stateBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"activity_state%d", activity.stateId]]  forState:UIControlStateDisabled];
            cell.nameLb.text = activity.activityName;
            cell.cutoffTimeLb.text = activity.cutoffTime;
            cell.userCountLb.text = [NSString stringWithFormat:@"报名人数：%d", activity.userCount];
            cell.activityTimeLb.text = [NSString stringWithFormat:@"活动时间：%@--%@", activity.starttime, activity.endtime];
            cell.contentLb.text = activity.content;
            return cell;
            
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
    //点击“下面20条”
    if (row >= [activitys count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        Activity *activity = [activitys objectAtIndex:[indexPath row]];
        ActivityDetailView *detailView = [[ActivityDetailView alloc] init];
        detailView.activityId = activity.activityId;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (IBAction)item1Action:(id)sender {
    [self.item1Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    findType = @"news";
    isLoadOver = NO;
    [self reload:NO];
}

- (IBAction)item2Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:nil forState:UIControlStateNormal];
    findType = @"myJoin";
    isLoadOver = NO;
    [self reload:NO];
}

- (IBAction)item3Action:(id)sender {
    [self.item1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item1Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.item2Btn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.item3btn setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
    [self.item3btn setBackgroundImage:[UIImage imageNamed:@"activity_tab_bg"] forState:UIControlStateNormal];
    findType = @"myInitiate";
    isLoadOver = NO;
    [self reload:NO];
}
@end
