//
//  CommodityClassView.m
//  WHDLife
//
//  Created by Seven on 15-1-16.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "CommodityClassView.h"
#import "CommodityClassCell.h"
#import "CommodityClass.h"

#import "CommDetailView.h"
#import "CommodityView.h"
#import "ActivityDetailView.h"
#import "CommodityDetailView.h"

@interface CommodityClassView ()

@end

@implementation CommodityClassView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"精品推送";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CommodityClassCell class] forCellWithReuseIdentifier:CommodityClassCellIdentifier];
//    [self.collectionView registerClass:[CommodityClassReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CommodityClassHead"];
    
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.collectionView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self refreshExpressData];
    
    [self getADVData];
}

- (void)refreshExpressData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取商品分类URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:@"40" forKey:@"countPerPages"];
        NSString *findExpressinInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCommodityClassByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findExpressinInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           [classes removeAllObjects];
                                           classes = [Tool readJsonStrToCommodityClassArray:operation.responseString];
                                           int n = [classes count] % 3;
                                           if(n > 0)
                                           {
                                               for (int i = 0; i < 3 - n; i++) {
                                                   CommodityClass *class = [[CommodityClass alloc] init];
                                                   class.classId = @"-1";
                                                   [classes addObject:class];
                                               }
                                           }
                                           [self.collectionView reloadData];
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
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [classes count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommodityClassCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommodityClassCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[CommodityClassCell class]]) {
                cell = (CommodityClassCell *)o;
                break;
            }
        }
    }
    int indexRow = [indexPath row];
    CommodityClass *cate = [classes objectAtIndex:indexRow];
    
    if ([cate.classId isEqualToString:@"-1"]) {
        cell.classImageIv.hidden = YES;
        cell.classNameLb.hidden = YES;
    }
    else
    {
        cell.classImageIv.hidden = NO;
        cell.classNameLb.hidden = NO;
        cell.classNameLb.text = cate.className;
        NSString *imageUrl = [NSString stringWithFormat:@"%@_200", cate.imgUrlFull];
        [cell.classImageIv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loadpic.png"]];
        
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(106, 106);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityClass *class = [classes objectAtIndex:[indexPath row]];
    if (class) {
        if ([class.classId isEqualToString:@"-1"] == NO) {
            CommodityView *commodityView = [[CommodityView alloc] init];
            commodityView.classOb = class;
            [self.navigationController pushViewController:commodityView animated:YES];
        }
    }
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
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self refreshExpressData];
    }
}

- (void)dealloc
{
    [self.collectionView setDelegate:nil];
}

- (void)viewDidUnload
{
    [self setCollectionView:nil];
    _refreshHeaderView = nil;
    [classes removeAllObjects];
    classes = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回headview或footview
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader){
//        CommodityClassReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CommodityClassHead" forIndexPath:indexPath];
//        reusableview = headerView;
////        [headerView getADVData];
//                self.advIv = headerView.advIv;
//        [self getADVData];
//    }
//    return reusableview;
//}

- (void)getADVData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        //生成获取广告URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"1141857157067500" forKey:@"typeId"];
        [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
        [param setValue:@"1" forKey:@"timeCon"];
        NSString *getADDataUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findAdInfoList] params:param];
        
        [[AFOSCClient sharedClient]getPath:getADDataUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToAdinfoArray:operation.responseString];
                                           int length = [advDatas count];
                                           
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               ADInfo *adv = [advDatas objectAtIndex:length-1];
                                               
                                               NSString *title = [NSString stringWithFormat:@"  %@\n", adv.adName];
                                               NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
                                               [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [adv.adName length] + 2)];
                                               
                                               NSString *content = [NSString stringWithFormat:@"  %@", adv.synopsis];
                                               NSMutableAttributedString *C_NSAS = [[NSMutableAttributedString alloc] initWithString:content];
                                               [C_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0] range:NSMakeRange(0, [content length])];
                                               
                                               [title_NSAS appendAttributedString:C_NSAS];
                                               
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:adv.imgUrlFull tag:length-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               ADInfo *adv = [advDatas objectAtIndex:i];
                                               
                                               NSString *title = [NSString stringWithFormat:@"  %@\n", adv.adName];
                                               NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
                                               [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [adv.adName length] + 2)];
                                               
                                               NSString *content = [NSString stringWithFormat:@"  %@", adv.synopsis];
                                               NSMutableAttributedString *C_NSAS = [[NSMutableAttributedString alloc] initWithString:content];
                                               [C_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0] range:NSMakeRange(0, [content length])];
                                               
                                               [title_NSAS appendAttributedString:C_NSAS];
                                               
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:adv.imgUrlFull tag:i];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               ADInfo *adv = [advDatas objectAtIndex:0];
                                               
                                               NSString *title = [NSString stringWithFormat:@"  %@\n", adv.adName];
                                               NSMutableAttributedString *title_NSAS = [[NSMutableAttributedString alloc] initWithString:title];
                                               [title_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14.0] range:NSMakeRange(0, [adv.adName length] + 2)];
                                               
                                               NSString *content = [NSString stringWithFormat:@"  %@", adv.synopsis];
                                               NSMutableAttributedString *C_NSAS = [[NSMutableAttributedString alloc] initWithString:content];
                                               [C_NSAS addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0] range:NSMakeRange(0, [content length])];
                                               
                                               [title_NSAS appendAttributedString:C_NSAS];
                                               
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:title_NSAS image:adv.imgUrlFull tag:0];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 135) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.advIv addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
                                       }
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

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    ADInfo *adv = (ADInfo *)[advDatas objectAtIndex:advIndex];
    if (adv)
    {
        //0：通知（如果URL为空就是广告）     1:活动      2：商品
        if (adv.expansionTypeId == 0) {
            if ([adv.url length] > 0) {
                NSString *pushDetailHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_pushDetailHtm ,adv.url];
                CommDetailView *detailView = [[CommDetailView alloc] init];
                detailView.titleStr = @"物业通知";
                detailView.urlStr = pushDetailHtm;
                [self.navigationController pushViewController:detailView animated:YES];
            }
            else
            {
                NSString *adDetailHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_adDetail ,adv.adId];
                CommDetailView *detailView = [[CommDetailView alloc] init];
                detailView.titleStr = @"详情";
                detailView.urlStr = adDetailHtm;
                detailView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailView animated:YES];
            }
        }
        else if (adv.expansionTypeId == 1) {
            ActivityDetailView *detailView = [[ActivityDetailView alloc] init];
            detailView.activityId = adv.url;
            [self.navigationController pushViewController:detailView animated:YES];
        }
        else if (adv.expansionTypeId == 2) {
            CommodityDetailView *detailView = [[CommodityDetailView alloc] init];
            detailView.commodityId = adv.url;
            [self.navigationController pushViewController:detailView animated:YES];
        }
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    advIndex = index;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
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
