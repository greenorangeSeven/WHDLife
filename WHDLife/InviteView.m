//
//  InviteView.m
//  WHDLife
//
//  Created by Seven on 15-1-22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "InviteView.h"
#import "NSString+STRegex.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

@interface InviteView ()
{
    UserInfo *userInfo;
}

@end

@implementation InviteView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"邀请家人";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.smsContentTv.editable = NO;
    self.smsContentTv.text = [NSString stringWithFormat:@"%@邀请您注册D.生活智慧社区，并加入他所在的房间，邀请码为：XXXXXX", userInfo.regUserName];
    [Tool roundTextView:self.smsContentTv andBorderWidth:1.0 andCornerRadius:5.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController setNeedSwipeShowMenu:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendAction:(id)sender {
    NSString *mobileStr = self.mobileNoTf.text;
    if (![mobileStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.sendBtn.enabled = NO;
    //生成注册URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:mobileStr forKey:@"mobileNo"];
    NSString *invitationSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_createInvitationCode] params:param];
    NSString *invitationUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_createInvitationCode];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:invitationUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:invitationSign forKey:@"sign"];
    [request setPostValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:mobileStr forKey:@"mobileNo"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestInvite:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"发送中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.sendBtn.enabled == NO)
    {
        self.sendBtn.enabled = YES;
    }
}

- (void)requestInvite:(ASIHTTPRequest *)request
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
        self.sendBtn.enabled = YES;
        return;
    }
    else
    {
        [Tool showCustomHUD:@"邀请发送成功" andView:self.parentView  andImage:@"37x-Failure.png" andAfterDelay:2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
