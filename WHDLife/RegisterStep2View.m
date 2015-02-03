//
//  RegisterStep2View.m
//  WHDLife
//
//  Created by Seven on 15-1-3.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "RegisterStep2View.h"
#import "NSString+STRegex.h"
#import "XGPush.h"
#import "MainTabView.h"
#import "LeftView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "CommDetailView.h"

@interface RegisterStep2View ()
{
    BOOL isAgree;
    NSTimer *_timer;
    int countDownTime;
}

@end

@implementation RegisterStep2View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"账号信息";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)getValidateCodeAction:(id)sender {
    NSString *mobileStr = self.mobileNoTf.text;
    if (![mobileStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.getValidataCodeBtn.enabled = NO;
    //生成验证码URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:mobileStr forKey:@"mobileNo"];
    NSString *createRegCodeListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_createRegCode] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:createRegCodeListUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreateRegCode:)];
    request.tag = 3;
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"验证码发送中" andView:self.view andHUD:request.hud];
}

- (void)requestCreateRegCode:(ASIHTTPRequest *)request
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
        self.finishBtn.enabled = YES;
        return;
    }
    else
    {
        [Tool showCustomHUD:@"验证码发送成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        [self startValidateCodeCountDown];
    }
}

- (void)startValidateCodeCountDown
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    countDownTime = 60;
}

- (void)timerFunc
{
    if (countDownTime > 0) {
        self.getValidataCodeBtn.enabled = NO;
        [self.getValidataCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%d)" ,countDownTime] forState:UIControlStateDisabled];
        [self.getValidataCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    else
    {
        self.getValidataCodeBtn.enabled = YES;
        [self.getValidataCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.getValidataCodeBtn setTitleColor:[UIColor colorWithRed:251/255.0 green:67/255.0 blue:79/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_timer invalidate];
    }
    countDownTime --;
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

- (IBAction)finishAction:(id)sender {
    NSString *mobileStr = self.mobileNoTf.text;
    NSString *validateCodeStr = self.validateCodeTf.text;
    NSString *regUserNameStr = self.regUserNameTf.text;
    NSString *nickNameStr = self.nickNameTf.text;
    NSString *pwdStr = self.passwordTf.text;
    NSString *pwdAgainStr = self.passwordAgainTf.text;
    if (![mobileStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (validateCodeStr == nil || [validateCodeStr length] == 0) {
        [Tool showCustomHUD:@"请输入验证码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (regUserNameStr == nil || [regUserNameStr length] == 0) {
        [Tool showCustomHUD:@"请输入姓名" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (nickNameStr == nil || [nickNameStr length] == 0) {
        [Tool showCustomHUD:@"请输入昵称" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([pwdStr isEqualToString:pwdAgainStr] == NO) {
        [Tool showCustomHUD:@"两次密码输入不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.finishBtn.enabled = NO;
    //生成注册URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.houseNumId forKey:@"numberId"];
    [param setValue:validateCodeStr forKey:@"validateCode"];
    [param setValue:mobileStr forKey:@"mobileNo"];
    [param setValue:pwdStr forKey:@"password"];
    [param setValue:regUserNameStr forKey:@"regUserName"];
    [param setValue:nickNameStr forKey:@"nickName"];
    NSString *regUserSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_regUser] params:param];
    NSString *regUserUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_regUser];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUserUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:self.houseNumId forKey:@"numberId"];
    [request setPostValue:validateCodeStr forKey:@"validateCode"];
    [request setPostValue:mobileStr forKey:@"mobileNo"];
    [request setPostValue:pwdStr forKey:@"password"];
    [request setPostValue:nickNameStr forKey:@"nickName"];
    [request setPostValue:regUserNameStr forKey:@"regUserName"];
    [request setPostValue:regUserSign forKey:@"sign"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestRegUser:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"注册中..." andView:self.view andHUD:request.hud];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.getValidataCodeBtn.enabled == NO)
    {
        self.getValidataCodeBtn.enabled = YES;
    }
    if(self.finishBtn.enabled == NO)
    {
        self.finishBtn.enabled = YES;
    }
}
- (void)requestRegUser:(ASIHTTPRequest *)request
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
        self.finishBtn.enabled = YES;
        return;
    }
    else
    {
        UserInfo *userInfo = [Tool readJsonStrToLoginUserInfo:request.responseString];
        //设置登录并保存用户信息
        UserModel *userModel = [UserModel Instance];
        [userModel saveIsLogin:YES];
        [userModel saveAccount:self.mobileNoTf.text andPwd:self.passwordTf.text];
        
        if([userInfo.rhUserHouseList count] > 0)
        {
            for (int i = 0; i < [userInfo.rhUserHouseList count]; i++) {
                UserHouse *userHouse = (UserHouse *)[userInfo.rhUserHouseList objectAtIndex:0];
                if (i == 0) {
                    userInfo.defaultUserHouse = userHouse;
                }
                else
                {
                    userHouse.isDefault = NO;
                }
            }
        }
        [[UserModel Instance] saveUserInfo:userInfo];
        [XGPush setTag:userInfo.defaultUserHouse.cellId];
        [self gotoTabbar];
    }
}

-(void)gotoTabbar
{
    AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    MainTabView *mainViewController=[[MainTabView alloc]initWithNibName:@"MainTabView" bundle:nil];
    
    LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
    
    appdele.sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    appdele.sideViewController.rootViewController=mainViewController;
    appdele.sideViewController.leftViewController=leftViewController;
    
    appdele.sideViewController.leftViewShowWidth=200;
    appdele.sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
    
    appdele.window.rootViewController = appdele.sideViewController;
}

- (IBAction)agreeAction:(id)sender {
    if (isAgree) {
        isAgree = NO;
        [self.agreeBtn setImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
        [self.finishBtn setEnabled:NO];
    }
    else
    {
        isAgree = YES;
        [self.agreeBtn setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateNormal];
        [self.finishBtn setEnabled:YES];
    }
}

- (IBAction)regServiceAction:(id)sender {
    NSString *helpHtm = [NSString stringWithFormat:@"%@%@%@", api_base_urlnotport, htm_regService, AccessId];
    CommDetailView *managerInfoView = [[CommDetailView alloc] init];
    managerInfoView.titleStr = @"使用条款";
    managerInfoView.urlStr = helpHtm;
    managerInfoView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:managerInfoView animated:YES];
}
@end
