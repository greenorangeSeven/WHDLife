//
//  FriendsPageView.m
//  WHDLife
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsPageView.h"
#import "FriendsTypeView.h"
#import "UIViewController+CWPopup.h"
#import "FriendsImgCell.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "FriendsMyView.h"
#import "FriendsDetailView.h"

@interface FriendsPageView ()<UICollectionViewDelegate,UICollectionViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,UICollectionViewDelegateWaterfallLayout>
{
    FriendsTypeView *friendsTypeView;
    UIButton *titleBtn;
    BOOL isShowedPop;
    
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //cell的宽度
    int imgWidth;
    
    //当前type的类型
    int typeId;
    
    MBProgressHUD *hud;
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSMutableArray *friendsList;
    
    UILabel *noDataLabel;
}

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation FriendsPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    typeId = 0;
    imgWidth = self.view.frame.size.width / 3 - 8;
    UIButton *btnLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    [btnLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLabel setTitle:@"全部" forState:UIControlStateNormal];
    btnLabel.backgroundColor = [UIColor clearColor];
    [btnLabel.imageView setContentMode:UIViewContentModeCenter];
    [btnLabel setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
    [btnLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnLabel addTarget:self action:@selector(showFriendsTypePopup:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn = btnLabel;
    self.navigationItem.titleView = btnLabel;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 19)];
    [rBtn addTarget:self action:@selector(showMyAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"header_my"] forState:UIControlStateNormal];
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    
    [self.collectionView registerClass:[FriendsImgCell class] forCellWithReuseIdentifier:@"FriendsImgCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.delegate = self;
    layout.columnCount = 3;
    layout.itemWidth = imgWidth;
    [self.collectionView setCollectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    friendsTypeView = [FriendsTypeView instance];
    friendsTypeView.frendsPage = self;
    [friendsTypeView setUserInteractionEnabled: YES];
    
    friendsList = [[NSMutableArray alloc] initWithCapacity:18];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 44)];
    noDataLabel.font = [UIFont boldSystemFontOfSize:18];
    noDataLabel.text = @"暂无数据";
    noDataLabel.textColor = [UIColor blackColor];
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textAlignment = UITextAlignmentCenter;
    noDataLabel.hidden = YES;
    [self.view addSubview:noDataLabel];
    
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.collectionView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self refreshTopicData:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController setNeedSwipeShowMenu:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)clear
{
    allCount = 0;
    [friendsList removeAllObjects];
    isLoadOver = NO;
}

#pragma mark 获取所有帖子
- (void)refreshTopicData:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/18 + 1;
        
        
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"18" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"stateId"];
        
        NSString *findTopicInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url,api_findTopicInfoByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findTopicInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSMutableArray *friendNews = [Tool readJsonStrToFriendsArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {

                                           int count = [friendNews count];
                                           allCount += count;
                                           if (count < 18)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [friendsList addObjectsFromArray:friendNews];
                                           
                                           [self.collectionView reloadData];
                                           
                                           if (allCount == 0) {
                                               noDataLabel.hidden = NO;
                                           }
                                           else
                                           {
                                               noDataLabel.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           if(!hud.hidden)
                                           {
                                               hud.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if(!hud.hidden)
                                       {
                                           hud.hidden = YES;
                                       }
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning)
                                       {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

#pragma mark 搜索我关注的人帖子
- (void)searchTopicByAttention:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/18 + 1;
        
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"18" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"stateId"];
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        
        NSString *findTopicInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url,api_findTopicInfoByAttention] params:param];
        [[AFOSCClient sharedClient]getPath:findTopicInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSMutableArray *friendNews = [Tool readJsonStrToFriendsArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           
                                           int count = [friendNews count];
                                           allCount += count;
                                           if (count < 18)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [friendsList addObjectsFromArray:friendNews];
                                           
                                           [self.collectionView reloadData];
                                           
                                           if (allCount == 0) {
                                               noDataLabel.hidden = NO;
                                           }
                                           else
                                           {
                                               noDataLabel.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           if(!hud.hidden)
                                           {
                                               hud.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if(!hud.hidden)
                                       {
                                           hud.hidden = YES;
                                       }
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning)
                                       {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

#pragma mark 搜索指定类别的帖子
- (void)searchTopicByType:(int)type andNoRefresh:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/18 + 1;
        
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"18" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"stateId"];
        [param setValue:[NSString stringWithFormat:@"%i",type - 2] forKey:@"typeId"];
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        if(userInfo.defaultUserHouse)
        {
            [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
        }
        
        NSString *findTopicInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url,api_findTopicInfoByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findTopicInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSMutableArray *friendNews = [Tool readJsonStrToFriendsArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           
                                           int count = [friendNews count];
                                           allCount += count;
                                           if (count < 18)
                                           {
                                               isLoadOver = YES;
                                           }
                                           [friendsList addObjectsFromArray:friendNews];
                                           
                                           [self.collectionView reloadData];
                                           
                                           if (allCount == 0) {
                                               noDataLabel.hidden = NO;
                                           }
                                           else
                                           {
                                               noDataLabel.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           if(!hud.hidden)
                                           {
                                               hud.hidden = YES;
                                           }
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if(!hud.hidden)
                                       {
                                           hud.hidden = YES;
                                       }
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning)
                                       {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

- (void)showFriendsTypePopup:(UIButton *)sender
{
    if(isShowedPop)
    {
        [sender setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
        [sender setEnabled: NO];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
            
        } completion:^(BOOL finished) {
            isShowedPop = NO;
            [sender setEnabled: YES];
        }];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"friends_arrow_top"] forState:UIControlStateNormal];
        [sender setEnabled: NO];
        friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
        [self.view addSubview:friendsTypeView];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, 0, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
        } completion:^(BOOL finished) {
            isShowedPop = YES;
            [sender setEnabled: YES];
        }];
    }
}

- (void)reloadTopicByType:(int)type andTitle :(NSString *)title
{
    if(isShowedPop)
    {
        [titleBtn setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [titleBtn setEnabled: NO];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
            
        } completion:^(BOOL finished)
        {
            isShowedPop = NO;
            [titleBtn setEnabled: YES];
            isLoadOver = NO;
            //如果当前显示的类别跟选择的类别相同则不需要刷新
            if(typeId == type)
            {
                return;
            }
            
            typeId = type;
            if(type == 0)
            {
                [self refreshTopicData:NO];
            }
            else if(type == 1)
            {
                [self searchTopicByAttention:NO];
            }
            else
            {
                [self searchTopicByType:type andNoRefresh:NO];
            }
        }];
    }
}

- (void)showMyAction:(id)sender
{
    FriendsMyView *friendsMyView = [[FriendsMyView alloc] init];
    friendsMyView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendsMyView animated:YES];
}

- (void)updateLayout
{
    UICollectionViewWaterfallLayout *layout =
    (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = 3;
    layout.itemWidth = imgWidth;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [friendsList count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsImgCell" forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommodityClassCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[FriendsImgCell class]]) {
                cell = (FriendsImgCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    FriendsList *cate = [friendsList objectAtIndex:indexRow];
    
    NSString *imgUrl = cate.imgUrlList[0];
    [cell bindData:imgUrl];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsList *fri = friendsList[indexPath.row];
    ImgList *imgList = fri.imgList[0];
    //计算缩放比
    float scale = (float)imgWidth / (float)imgList.picWidth;
    //获得缩放后的高度
    float imgHeight = imgList.picHeight * scale;
    return imgHeight;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsList *fri = friendsList[indexPath.row];
    FriendsDetailView *detailView = [[FriendsDetailView alloc] init];
    detailView.hidesBottomBarWhenPushed = YES;
    detailView.topicId = fri.topicId;
    [self.navigationController pushViewController:detailView animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
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
    if ([UserModel Instance].isNetworkRunning)
    {
        isLoadOver = NO;
        if(typeId == 0)
        {
            [self refreshTopicData:NO];
        }
        else if(typeId == 1)
        {
            [self searchTopicByAttention:NO];
        }
        else
        {
            [self searchTopicByType:typeId andNoRefresh:NO];
        }
    }
}

- (void)dealloc
{
    [self.collectionView setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
