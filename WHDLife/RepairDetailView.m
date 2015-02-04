//
//  RepairDetailView.m
//  WHDLife
//
//  Created by Seven on 15-1-11.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RepairDetailView.h"
#import "RepairBasic.h"
#import "RepairDispatch.h"
#import "RepairFinish.h"
#import "RepairResult.h"
#import "RepairBasicCell.h"
#import "RepairDispatchCell.h"
#import "RepairFinishCell.h"
#import "RepairResultCell.h"
#import "AMRatingControl.h"

@interface RepairDetailView ()
{
    MBProgressHUD *hud;
    NSMutableArray *detailItems;
    NSArray *repairResultArray;
    //如果stateSort==4则为已评价
    NSString *stateSort;
}

@end

@implementation RepairDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"报修单";
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getRepairDetailData];
}

- (void)closeAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getRepairDetailData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
        //生成获取报修详情URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.repairWorkId forKey:@"repairWorkId"];
        NSString *getRepairDetailUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findRepairWorkDetaile] params:param];
        
        [[AFOSCClient sharedClient]getPath:getRepairDetailUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [detailItems removeAllObjects];
                                       @try {
                                           detailItems = [Tool readJsonStrToRepairItemArray:operation.responseString];
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
        RepairBasic *basic = [detailItems objectAtIndex:row];
        stateSort = basic.stateSort;
        return 230.0 + basic.viewAddHeight ;
    }
    else if (row == 1) {
        return 72.0 ;
    }
    else if (row == 2) {
        RepairFinish *finish = [detailItems objectAtIndex:row];
        return 176.0 + finish.viewAddHeight ;
    }
    else  if (row == 3) {
        RepairResult *result = [detailItems objectAtIndex:row];
        return 279.0 + result.viewAddHeight;
    }
    else
    {
        return 0.0;
    }
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (row == 0) {
        RepairBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairBasicCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairBasicCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[RepairBasicCell class]]) {
                    cell = (RepairBasicCell *)o;
                    break;
                }
            }
        }
        RepairBasic *basic = [detailItems objectAtIndex:row];
        
        stateSort = basic.stateSort;
        
        cell.repairTimeLb.text = basic.starttime;
        cell.repairNameLb.text = basic.repairTitle;
        cell.repairContentLb.text = basic.repairContent;
        
        CGRect contentFrame = cell.repairContentLb.frame;
        contentFrame.size.height = basic.contentHeight;
        cell.repairContentLb.frame = contentFrame;
        
        CGRect imageFrame = cell.repairImageFrameView.frame;
        imageFrame.origin.y += basic.viewAddHeight;
        cell.repairImageFrameView.frame = imageFrame;
        
        CGRect basicFrame = cell.basicView.frame;
        basicFrame.size.height += basic.viewAddHeight;
        cell.basicView.frame = basicFrame;
        
        if ([basic.fullImgList count] > 0) {
            //加载图片
            cell.navigationController = self.navigationController;
            [cell loadRepairImage:basic.fullImgList];
        }
        else
        {
            UILabel *noImageLb = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 25.0, 310.0, 67.0)];
            noImageLb.font = [UIFont systemFontOfSize:14];
            noImageLb.textAlignment = UITextAlignmentCenter;
            noImageLb.text = @"无照片";
            [cell.repairImageFrameView addSubview:noImageLb];
        }
        
        return cell;
    }
    else if (row == 1) {
        RepairDispatchCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairDispatchCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairDispatchCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[RepairDispatchCell class]]) {
                    cell = (RepairDispatchCell *)o;
                    break;
                }
            }
        }
        RepairDispatch *dispatch = [detailItems objectAtIndex:row];
        cell.dispatchTimeLb.text = dispatch.starttime;
        cell.dispatchManLb.text = [NSString stringWithFormat:@"%@(%@)", dispatch.repairmanName, dispatch.mobileNo];
        return cell;
    }
    else if (row == 2) {
        RepairFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairFinishCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairFinishCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[RepairFinishCell class]]) {
                    cell = (RepairFinishCell *)o;
                    break;
                }
            }
        }
        RepairFinish *finish = [detailItems objectAtIndex:row];
        cell.finishTimeLb.text = finish.starttime;
        cell.finishContentLb.text = finish.runContent;
        cell.finishCostLb.text = [NSString stringWithFormat:@"%.2f元", finish.cost];
        
        CGRect contentFrame = cell.finishContentLb.frame;
        contentFrame.size.height = finish.contentHeight;
        cell.finishContentLb.frame = contentFrame;
        
        CGRect finishFrame = cell.finishView.frame;
        finishFrame.size.height += finish.viewAddHeight;
        cell.finishView.frame = finishFrame;
        
        CGRect bottomFrame = cell.bottomView.frame;
        bottomFrame.origin.y += finish.viewAddHeight;
        cell.bottomView.frame = bottomFrame;
        return cell;
    }
    else if (row == 3)
    {
        RepairResultCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairResultCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairResultCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[RepairResultCell class]]) {
                    cell = (RepairResultCell *)o;
                    break;
                }
            }
        }
        RepairResult *result = [detailItems objectAtIndex:row];
        
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
        imageFrame.origin.y += result.viewAddHeight;
        cell.resultImageFrameView.frame = imageFrame;
        
        CGRect basicFrame = cell.resultView.frame;
        basicFrame.size.height += result.viewAddHeight;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
