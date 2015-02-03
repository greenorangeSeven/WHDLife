//
//  SuitDetailView.m
//  BBK
//
//  Created by Seven on 14-12-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "SuitDetailView.h"
#import "SuitBasic.h"
#import "SuitReply.h"
#import "SuitResult.h"
#import "SuitBasicCell.h"
#import "SuitReplyCell.h"
#import "SuitResutCell.h"
#import "SuitReply.h"
#import "AMRatingControl.h"

@interface SuitDetailView ()
{
    MBProgressHUD *hud;
    NSMutableArray *detailItems;
    NSArray *suitResultArray;
    //如果suitStateId==2则为已评价
    int suitStateId;
}

@property (weak, nonatomic) UITextView *userRecontent;
@property (weak, nonatomic) UIButton *submitScoreBtn;

@end

@implementation SuitDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"投诉建议";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    if([self.present isEqualToString:@"present"] == YES)
    {
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle: @"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction)];
        leftBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getSuitDetailData];
}

- (void)closeAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getSuitDetailData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
        //生成获取报修详情URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.suitWorkId forKey:@"suitWorkId"];
        NSString *getSuitDetailUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findSuitWorkDetail] params:param];
        
        [[AFOSCClient sharedClient]getPath:getSuitDetailUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [detailItems removeAllObjects];
                                       @try {
                                           detailItems = [Tool readJsonStrToSuitItemArray:operation.responseString];
                                           [self.tableView reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
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

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return detailItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (row == 0) {
        SuitBasic *basic = [detailItems objectAtIndex:row];
        suitStateId = basic.suitStateId;
        return 230.0 + basic.viewAddHeight;
    }
    else if (row == 1) {
        SuitReply *reply = [detailItems objectAtIndex:row];
        return 85.0 + reply.viewAddHeight ;
    }
    else  if (row == 2) {
        SuitResult *result = [detailItems objectAtIndex:row];
        return 279.0 + result.addViewHeight;
    }
    else
    {
        return 0.0;
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
    if (row == 0) {
        SuitBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:SuitBasicCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SuitBasicCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[SuitBasicCell class]]) {
                    cell = (SuitBasicCell *)o;
                    break;
                }
            }
        }
        SuitBasic *basic = [detailItems objectAtIndex:row];
        
        suitStateId = basic.suitStateId;
        
        cell.suitTimeLb.text = basic.starttime;
        cell.suitTitleLb.text = basic.suitTitle;
        cell.suitContentLb.text = basic.suitContent;
        
        CGRect contentFrame = cell.suitContentLb.frame;
        contentFrame.size.height = basic.contentHeight;
        cell.suitContentLb.frame = contentFrame;
        
        CGRect imageFrame = cell.suitImageFrameView.frame;
        imageFrame.origin.y += basic.viewAddHeight;
        cell.suitImageFrameView.frame = imageFrame;
        
        CGRect basicFrame = cell.basicView.frame;
        basicFrame.size.height += basic.viewAddHeight;
        cell.basicView.frame = basicFrame;
        
        if ([basic.fullImgList count] > 0) {
            //加载图片
            cell.navigationController = self.navigationController;
            [cell loadSuitImage:basic.fullImgList];
        }
        else
        {
            UILabel *noImageLb = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 310.0, 67.0)];
            noImageLb.font = [UIFont systemFontOfSize:14];
            noImageLb.textAlignment = UITextAlignmentCenter;
            noImageLb.text = @"无照片";
            [cell.suitImageFrameView addSubview:noImageLb];
        }
        
        return cell;
    }
    else if (row == 1) {
        SuitReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:SuitReplyCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SuitReplyCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[SuitReplyCell class]]) {
                    cell = (SuitReplyCell *)o;
                    break;
                }
            }
        }
        SuitReply *reply = [detailItems objectAtIndex:row];
        cell.repalyTimeLb.text = reply.replyTime;
        cell.repalyContentLb.text = reply.replyContent;
        
        CGRect contentFrame = cell.repalyContentLb.frame;
        contentFrame.size.height = reply.contentHeight;
        cell.repalyContentLb.frame = contentFrame;
        
        CGRect bottomFrame = cell.repalyContentFrameView.frame;
        bottomFrame.size.height += reply.viewAddHeight;
        cell.repalyContentFrameView.frame = bottomFrame;
        return cell;
    }
    else if (row == 2)
    {
        SuitResutCell *cell = [tableView dequeueReusableCellWithIdentifier:SuitResutCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SuitResutCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[SuitResutCell class]]) {
                    cell = (SuitResutCell *)o;
                    break;
                }
            }
        }
        SuitResult *result = [detailItems objectAtIndex:row];
        
        //星级评价
        UIImage *dot, *star;
        dot = [UIImage imageNamed:@"star_nor"];
        star = [UIImage imageNamed:@"star_pro"];
        
        AMRatingControl *scoreControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
        scoreControl.targer = self;
        [scoreControl setRating:result.score];
        
        [cell.scoreLb addSubview:scoreControl];
        
        cell.titleLb.text = result.replyTitle;
        cell.comtentLb.text = result.userRecontent;
        
        CGRect contentFrame = cell.comtentLb.frame;
        contentFrame.size.height = result.contentHeight;
        cell.comtentLb.frame = contentFrame;
        
        CGRect imageFrame = cell.resultImageFrameView.frame;
        imageFrame.origin.y += result.addViewHeight;
        cell.resultImageFrameView.frame = imageFrame;
        
        CGRect basicFrame = cell.resultView.frame;
        basicFrame.size.height += result.addViewHeight;
        cell.resultView.frame = basicFrame;
        
        if ([result.fullImgList count] > 0) {
            //加载图片
            cell.navigationController = self.navigationController;
            [cell loadRepairImage:result.fullImgList];
        }
        else
        {
            UILabel *noImageLb = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 310.0, 67.0)];
            noImageLb.font = [UIFont systemFontOfSize:14];
            noImageLb.textAlignment = UITextAlignmentCenter;
            noImageLb.text = @"无照片";
            [cell.resultImageFrameView addSubview:noImageLb];
        }
        
        return cell;
    }
    else
    {
        return nil;
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

@end