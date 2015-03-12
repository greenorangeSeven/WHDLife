//
//  GatherTableView.m
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "GatherTableView.h"
#import "GatherTableCell.h"
#import "GatherSelectView.h"

@interface GatherTableView ()
{
    UserInfo *userInfo;
    NSMutableArray *seleteArray;
}

@end

@implementation GatherTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    float tableHeight = self.frameView.frame.size.height - 50;
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, tableHeight);
    self.footerView.frame = CGRectMake(0, tableHeight, self.view.frame.size.width, self.footerView.frame.size.height);
    
    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(0, 0, 100, 20) style:kSSCheckBoxViewStyleGlossy checked:NO];
    [cb setText:@"全选"];
    [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            if ([express count] > 0) {
                for (ExpressInfo *e in express) {
                    e.isChecked = YES;
                    [self.tableView reloadData];
                }
            }
        }
        else
        {
            if ([express count] > 0) {
                for (ExpressInfo *e in express) {
                    e.isChecked = NO;
                    [self.tableView reloadData];
                }
            }
        }
    }];
    [self.checkAll addSubview:cb];
    seleteArray = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    
    express = [[NSMutableArray alloc] initWithCapacity:40];
    [self refreshExpressData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshed:) name:Notification_RefreshGatherTable object:nil];
}

- (void)refreshed:(NSNotification *)notification
{
    [self.tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

- (IBAction)selectTypeAction:(id)sender {
    [seleteArray removeAllObjects];
    for (ExpressInfo *e in express) {
        if (e.isChecked) {
            [seleteArray addObject:e.expressId];
        }
    }
    
    if ([seleteArray count] == 0) {
        [Tool showCustomHUD:@"请选择快件" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    NSString *idStrings = [seleteArray componentsJoinedByString:@","];
    
    GatherSelectView *selectTypeView = [[GatherSelectView alloc] init];
    selectTypeView.expressId = idStrings;
    selectTypeView.parentView = self.frameView;
    [self.navigationController pushViewController:selectTypeView animated:YES];
}

- (void)refreshExpressData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取物业物品URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:@"40" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"stateId"];
        NSString *findExpressinInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findExpressinInfoByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findExpressinInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           [express removeAllObjects];
                                           express = [Tool readJsonStrToExpressArray:operation.responseString];
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
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.frameView andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([express count] == 0)
    {
        return 1;
    }
    else
    {
        return express.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([express count] > 0) {
        GatherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:GatherTableCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"GatherTableCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[GatherTableCell class]]) {
                    cell = (GatherTableCell *)o;
                    break;
                }
            }
        }
        int row = [indexPath row];
        ExpressInfo *e = [express objectAtIndex:row];
        cell.expressNumLb.text = [NSString stringWithFormat:@"快递单号：%@", e.expressOrder];
        SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(5, 10, 20, 20) style:kSSCheckBoxViewStyleGlossy checked:e.isChecked];
        cb.enabled = NO;
        [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
            if (cbv.checked) {
                if (e) {
                    e.isChecked = YES;
                }
            }
            else
            {
                if (e) {
                    e.isChecked = NO;
                }
            }
        }];
        [cell addSubview:cb];
        return cell;
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:NO andLoadOverString:@"暂无数据" andLoadingString:@"暂无数据" andIsLoading:NO];
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    if (row >= [express count]) {
        return;
    }
    else
    {
        ExpressInfo *e = [express objectAtIndex:row];
        if(e)
        {
            if(e.isChecked)
            {
                e.isChecked = NO;
            }
            else
            {
                e.isChecked = YES;
            }
            [self.tableView reloadData];
        }
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
        [self refreshExpressData];
    }
}

- (void)dealloc
{
    [self.tableView setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [express removeAllObjects];
    express = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
