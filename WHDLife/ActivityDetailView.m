//
//  ActivityDetailView.m
//  WHDLife
//
//  Created by Seven on 15-1-8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ActivityDetailView.h"
#import "UIImageView+WebCache.h"
#import "Activity.h"
#import "ActivityPlayersView.h"

@interface ActivityDetailView ()
{
    Activity *activityDetail;
    UserInfo *userInfo;
    UIWebView *phoneWebView;
    MBProgressHUD *hud;
}

@end

@implementation ActivityDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"活动详情";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    userInfo = [[UserModel Instance] getUserInfo];
    [self getActivityDetail];
}

- (void)getActivityDetail
{
    [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
    //生成获取活动详情URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:self.activityId forKey:@"activityId"];

    NSString *getActivityDetailUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCellActivityById] params:param];
    
    [[AFOSCClient sharedClient]getPath:getActivityDetailUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       activityDetail = [Tool readJsonStrToActivityDetail:operation.responseString];
                                       
                                       if([activityDetail.regUserId isEqualToString:userInfo.regUserId])
                                       {
                                           UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"参与人" style:UIBarButtonItemStyleBordered target:self action:@selector(playersAction:)];
                                           self.navigationItem.rightBarButtonItem = rightBtn;
                                       }
                                       
                                       [self.ImageIv setImageWithURL:[NSURL URLWithString:activityDetail.imgUrlFull] placeholderImage:[UIImage imageNamed:@"loadingpic.png"]];
                                       self.nameLb.text = activityDetail.activityName;
                                       self.addressLb.text = [NSString stringWithFormat:@"地点：%@", activityDetail.address];
                                       self.contactManLb.text = [NSString stringWithFormat:@"联系人：%@(%@)", activityDetail.contactMan, activityDetail.phone];
                                       UITapGestureRecognizer *contactManTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactManClick)];
                                       [self.contactManLb addGestureRecognizer:contactManTap];
                                       
                                       self.timeLb.text = [NSString stringWithFormat:@"活动时间：%@--%@", activityDetail.starttime, activityDetail.endtime];
                                       self.cutoffLb.text = [NSString stringWithFormat:@"报名截止时间：%@", activityDetail.cutoffTime];
                                       self.contentLb.text = [NSString stringWithFormat:@"详情：%@", activityDetail.content];
                                       self.countUserLb.text = [NSString stringWithFormat:@"人数：%d/%d", activityDetail.userCount, activityDetail.totalCount];
                                       
                                       if ([activityDetail.isJoin isEqualToString:@"0"] == YES) {
                                           [self.joinBtn setTitle:@"报名" forState:UIControlStateNormal];
                                       }
                                       else if ([activityDetail.isJoin isEqualToString:@"1"] == YES)
                                       {
                                           [self.joinBtn setTitle:@"取消" forState:UIControlStateNormal];
                                       }
                                       
                                       if (activityDetail.stateId == 4)
                                       {
                                           [self.joinBtn setEnabled:NO];
                                           [self.joinBtn setTitle:@"已截止" forState:UIControlStateDisabled];
                                       }

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
                                   if (hud != nil) {
                                       [hud hide:YES];
                                   }
                                   if ([UserModel Instance].isNetworkRunning == NO) {
                                       return;
                                   }
                                   if ([UserModel Instance].isNetworkRunning) {
                                       [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                   }
                               }];
}

- (void)playersAction:(id)sender
{
    ActivityPlayersView *detailView = [[ActivityPlayersView alloc] init];
    detailView.activityId = activityDetail.activityId;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)contactManClick
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", activityDetail.phone]];
    if (!phoneWebView) {
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
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

- (IBAction)joinAction:(id)sender {
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        
        //加入/取消活动
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.activityId forKey:@"activityId"];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        NSString *addCancelInActivityUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addCancelInActivity] params:param];
        [[AFOSCClient sharedClient]getPath:addCancelInActivityUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
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
                                               NSString *hudStr = @"";
                                               if([activityDetail.isJoin isEqualToString:@"1"] == YES)
                                               {
                                                   hudStr = @"取消报名";
                                                   activityDetail.isJoin = @"0";
                                                   [self.joinBtn setTitle:@"报名" forState:UIControlStateNormal];
                                               }
                                               else
                                               {
                                                   hudStr = @"报名成功";
                                                   activityDetail.isJoin = @"1";
                                                   [self.joinBtn setTitle:@"取消" forState:UIControlStateNormal];
                                               }
                                               [Tool showCustomHUD:hudStr andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                           }
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
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
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

@end
