//
//  LeftView.m
//  WHDLife
//
//  Created by Seven on 15-1-6.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LeftView.h"
#import "UIImageView+WebCache.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "BasicSettingView.h"
#import "YRSideViewController.h"
#import "MainTabView.h"
#import "InviteView.h"
#import "CommDetailView.h"
#import "MySettingView.h"

@interface LeftView ()
{
    UserInfo *userInfo;
    UIImage *uploadFace;
    NSString *appPath;
}

@property (strong, nonatomic) YRSideViewController *sideViewController;

@end

@implementation LeftView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //图片圆形处理
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius=self.faceIv.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    self.faceIv.backgroundColor = [UIColor whiteColor];
    
    self.facebgLb.layer.masksToBounds=YES;
    self.facebgLb.layer.cornerRadius=self.facebgLb.frame.size.width/2;    //最重要的是这个地方要设成view高的一半
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sideViewController = [delegate sideViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userInfo = [[UserModel Instance] getUserInfo];
    [self.faceIv setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    self.nickNameLb.text = userInfo.nickName;
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

- (IBAction)updateFaceAcion:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (IBAction)logoutAction:(id)sender {
    //删除用户信息
    UserModel *userModel = [UserModel Instance];
    [userModel saveIsLogin:NO];
    [userModel logoutUser];
    [userModel saveAccount:@"" andPwd:@""];
    
    //    UserHouse *defaultHouse = [userModel getUserInfo].defaultUserHouse;
    //    [XGPush delTag:defaultHouse.cellId];
    
    LoginView *loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginView];
    AppDelegate *appdele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdele.window.rootViewController = loginNav;
}

- (IBAction)checkVersionUpdate:(id)sender {
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成版本更新URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"0" forKey:@"sysType"];
        NSString *findSysUpdateUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findSysUpdate] params:param];
        
        [[AFOSCClient sharedClient]getPath:findSysUpdateUrl parameters:Nil
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
                                               NSString *appversion = [[json objectForKey:@"data"] objectForKey:@"version"];
                                               appPath = [[json objectForKey:@"data"] objectForKey:@"fileurl"];
                                               if( [appversion intValue] > [AppVersionCode intValue])
                                               {
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"D.生活有新版了\n您需要更新吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                                                   alert.tag = 0;
                                                   [alert show];
                                               }
                                               else
                                               {
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前已是最新版本！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                                                   [alert show];
                                               }
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"获取出错");
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                   }];
    }
}

- (IBAction)basicSettingAction:(id)sender {
    [self.sideViewController hideSideViewController:YES];
    BasicSettingView *basicSetting = [[BasicSettingView alloc] init];
    basicSetting.hidesBottomBarWhenPushed = YES;
    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    [mainTab.mainPageNav pushViewController:basicSetting animated:YES];
    
    //    MySettingView *mysettingView = [[MySettingView alloc] init];
    //    mysettingView.hidesBottomBarWhenPushed = YES;
    //    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    //    [mainTab.mainPageNav pushViewController:mysettingView animated:YES];
    
    //    MyFrameView *myView = [[MyFrameView alloc] init];
    //    myView.hidesBottomBarWhenPushed = YES;
    //    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    //    [mainTab.mainPageNav pushViewController:myView animated:YES];
}

- (IBAction)inviteAction:(id)sender {
    [self.sideViewController hideSideViewController:YES];
    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    InviteView *inviteView = [[InviteView alloc] init];
    inviteView.parentView = mainTab.view;
    inviteView.hidesBottomBarWhenPushed = YES;
    [mainTab.mainPageNav pushViewController:inviteView animated:YES];
}

- (IBAction)helpPageAction:(id)sender {
    NSString *helpHtm = [NSString stringWithFormat:@"%@%@", api_base_urlnotport, htm_help];
    CommDetailView *managerInfoView = [[CommDetailView alloc] init];
    managerInfoView.titleStr = @"帮助手册";
    managerInfoView.urlStr = helpHtm;
    managerInfoView.hidesBottomBarWhenPushed = YES;
    
    [self.sideViewController hideSideViewController:YES];
    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    [mainTab.mainPageNav pushViewController:managerInfoView animated:YES];
}

- (IBAction)goMyPageAction:(id)sender {
    [self.sideViewController hideSideViewController:YES];
    MySettingView *mysettingView = [[MySettingView alloc] init];
    mysettingView.hidesBottomBarWhenPushed = YES;
    MainTabView *mainTab = (MainTabView *)self.sideViewController.rootViewController;
    [mainTab.mainPageNav pushViewController:mysettingView animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            //            NSString *updateUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", appPath];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appPath]];
        }
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.faceIv.image = editedImage;
    uploadFace = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //生成更换头像URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        NSString *changePhotoSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPhoto] params:param];
        
        NSString *changePhotoUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPhoto] params:param];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changePhotoUrl]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setTimeOutSeconds:30];
        [request setPostValue:AccessId forKey:@"accessId"];
        [request setPostValue:changePhotoSign forKey:@"sign"];
        [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
        [request addData:UIImageJPEGRepresentation(uploadFace, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestChangeUserPhoto:)];
        [request startAsynchronous];
        
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"头像更新..." andView:self.view andHUD:request.hud];
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
}

- (void)requestChangeUserPhoto:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"%@", request.responseString);
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
        return;
    }
    else
    {
        NSString *userPhoto = [json objectForKey:@"data"];
        [[UserModel Instance] saveValue:userPhoto ForKey:@"photoFull"];
        [self.faceIv setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        userInfo.photoFull = userPhoto;
        UserModel *userModel = [UserModel Instance];
        [userModel saveUserInfo:userInfo];
    }
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //使用前置摄像头
                //                if ([self isFrontCameraAvailable]) {
                //                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                //                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
