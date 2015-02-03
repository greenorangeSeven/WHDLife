//
//  LoginView.m
//  WHDLife
//
//  Created by Seven on 15-1-3.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LoginView.h"
#import "RegisterStep1View.h"
#import "YRSideViewController.h"
#import "XGPush.h"
#import "MainTabView.h"
#import "LeftView.h"
#import "AppDelegate.h"
#import "ActivityInitiateView.h"
#import "ResetPassWordView.h"

@interface LoginView ()

@end

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSString *mobileStr = self.mobileNoTf.text;
    NSString *pwdStr = self.passwordTf.text;
    if (mobileStr == nil || [mobileStr length] == 0) {
        [Tool showCustomHUD:@"请填写手机号或邮箱" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.loginBtn.enabled = NO;
    //生成登陆URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:mobileStr forKey:@"loginName"];
    [param setValue:pwdStr forKey:@"password"];
    NSString *loginUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_login] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"登录中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.loginBtn.enabled == NO)
    {
        self.loginBtn.enabled = YES;
    }
}
- (void)requestLogin:(ASIHTTPRequest *)request
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
        self.loginBtn.enabled = YES;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)findPasswordAction:(id)sender {
    ResetPassWordView *resetPwd = [[ResetPassWordView alloc] init];
    resetPwd.parentView = self.view;
    [self.navigationController pushViewController:resetPwd animated:YES];
}

- (IBAction)registerAction:(id)sender {
    RegisterStep1View *register1 = [[RegisterStep1View alloc] init];
    [self.navigationController pushViewController:register1 animated:YES];
}
- (IBAction)visitorAction:(id)sender {
    
//    ActivityInitiateView *register1 = [[ActivityInitiateView alloc] init];
//    [self.navigationController pushViewController:register1 animated:YES];
    
//    [[SliderViewController sharedSliderController] showLeftViewController];
}
@end
