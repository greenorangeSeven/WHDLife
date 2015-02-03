//
//  ChangePwdView.m
//  WHDLife
//
//  Created by Seven on 15-1-25.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ChangePwdView.h"

@interface ChangePwdView ()

@property (nonatomic, strong) NSArray *fieldArray;

@end

@implementation ChangePwdView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"密码修改";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"修改" style:UIBarButtonItemStyleBordered target:self action:@selector(modifyPassWordAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.fieldArray = @[self.oldPassWordTf, self.newsPassWordTf, self.newsPassWordAginTf];
}

- (void)modifyPassWordAction:(id)sender
{
    for (UITextField *field in self.fieldArray)
    {
        [field resignFirstResponder];
    }
    
    NSString *oldPassWordStr = self.oldPassWordTf.text;
    NSString *newsPassWordStr = self.newsPassWordTf.text;
    NSString *newsPassWordAginStr = self.newsPassWordAginTf.text;
    if ([oldPassWordStr length] > 0)
    {
        if ([newsPassWordStr length] == 0) {
            [Tool showCustomHUD:@"请输入新密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            return;
        }
        if ([newsPassWordStr isEqualToString:newsPassWordAginStr] == NO) {
            [Tool showCustomHUD:@"密码确认不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            return;
        }
    }
    if ([newsPassWordStr length] > 0)
    {
        if ([oldPassWordStr length] == 0) {
            [Tool showCustomHUD:@"请输入旧密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            return;
        }
        if ([newsPassWordStr isEqualToString:newsPassWordAginStr] == NO) {
            [Tool showCustomHUD:@"密码确认不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            return;
        }
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    //资料修改URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:oldPassWordStr forKey:@"oldPassword"];
    [param setValue:newsPassWordStr forKey:@"password"];
    NSString *modifySign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPwd] params:param];
    NSString *modifyUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPwd];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:modifyUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:modifySign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:oldPassWordStr forKey:@"oldPassword"];
    [request setPostValue:newsPassWordStr forKey:@"password"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestModify:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"资料修改..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.navigationItem.rightBarButtonItem.enabled == NO)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)requestModify:(ASIHTTPRequest *)request
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
    }
    else
    {
        UserModel *userModel = [UserModel Instance];
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        if ([self.oldPassWordTf.text length] > 0 && [self.newsPassWordTf.text length] > 0)
        {
            [userModel saveAccount:[userModel getUserValueForKey:@"Account"] andPwd:self.newsPassWordTf.text];
        }
        [userModel saveUserInfo:userInfo];
        [Tool showCustomHUD:@"修改成功" andView:self.parentView  andImage:@"37x-Failure.png" andAfterDelay:2];
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
