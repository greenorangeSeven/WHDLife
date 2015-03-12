//
//  MySettingView.m
//  WHDLife
//
//  Created by Seven on 15-1-24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MySettingView.h"
#import "ChangePwdView.h"
#import "ChangeHouseView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

@interface MySettingView ()
{
    UserInfo *userInfo;
    UIImage *uploadFace;
    UIImage *uploadBg;
    NSString *uploadType;//0：上传头像，1：上传背景
}

@property (nonatomic, strong) NSArray *fieldArray;

@end

@implementation MySettingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"账户设置";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(modifyUserInfoAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.fieldArray = @[self.userNameTf, self.nameTf, self.emailTf];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    if ([userInfo.email length] > 0) {
        self.emailTf.enabled = NO;
        self.emailTf.textColor = [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0];
    }
    
    [Tool roundTextView:self.bg1View andBorderWidth:1.0 andCornerRadius:5.0];
    [Tool roundTextView:self.bg2View andBorderWidth:1.0 andCornerRadius:5.0];
    
    //图片圆形处理
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius=self.faceIv.frame.size.width/2;    //最重要的是这个地方要设成imgview高的一半
    self.faceIv.backgroundColor = [UIColor whiteColor];
    
    self.facebgLb.layer.masksToBounds=YES;
    self.facebgLb.layer.cornerRadius=self.facebgLb.frame.size.width/2;    //最重要的是这个地方要设成view高的一半
    
    [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    [self.mybgImageIv sd_setImageWithURL:[NSURL URLWithString:userInfo.bgImgFull] placeholderImage:[UIImage imageNamed:@"my_bg"]];
    self.nickNameLb.text = userInfo.nickName;
    self.userNameTf.text = userInfo.nickName;
    self.telphoneTf.text = userInfo.mobileNo;
    self.nameTf.text = userInfo.regUserName;
    self.emailTf.text = userInfo.email;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@%@", userInfo.defaultUserHouse.cellName, userInfo.defaultUserHouse.regionName, userInfo.defaultUserHouse.buildingName, userInfo.defaultUserHouse.unitName,userInfo.defaultUserHouse.numberName];
    [self.changeHouseBtn setTitle:userInfo.defaultUserHouse.cellName forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController setNeedSwipeShowMenu:NO];
}

- (void)modifyUserInfoAction:(id)sender
{
    for (UITextField *field in self.fieldArray)
    {
        [field resignFirstResponder];
    }
    
    NSString *nickNameStr = self.userNameTf.text;
    NSString *nameStr = self.nameTf.text;
    NSString *emailStr = self.emailTf.text;
    if ([nickNameStr length] == 0) {
        [Tool showCustomHUD:@"昵称不能为空" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([nameStr length] == 0) {
        [Tool showCustomHUD:@"姓名不能为空" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([emailStr length] == 0) {
        [Tool showCustomHUD:@"邮箱不能为空" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //资料修改URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:nickNameStr forKey:@"nickName"];
    [param setValue:nameStr forKey:@"regUserName"];
    [param setValue:emailStr forKey:@"email"];

    NSString *modifySign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_modiUserInfo] params:param];
    NSString *modifyUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_modiUserInfo];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:modifyUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:modifySign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:nickNameStr forKey:@"nickName"];
    [request setPostValue:nameStr forKey:@"regUserName"];
    [request setPostValue:emailStr forKey:@"email"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestModify:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"资料修改..." andView:self.view andHUD:request.hud];
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
        userInfo.nickName = self.userNameTf.text;
        userInfo.regUserName = self.nameTf.text;
        userInfo.email = self.emailTf.text;
        [userModel saveUserInfo:userInfo];
        [Tool showCustomHUD:@"修改成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
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

- (IBAction)updateFaceAction:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    uploadType = @"0";
    [choiceSheet showInView:self.view];
}

- (IBAction)updateMyBgAction:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    uploadType = @"1";
    [choiceSheet showInView:self.view];
}

- (IBAction)changePwdAction:(id)sender {
    ChangePwdView *changePwdView = [[ChangePwdView alloc] init];
    changePwdView.parentView = self.view;
    [self.navigationController pushViewController:changePwdView animated:YES];
}

- (IBAction)changeHouseAction:(id)sender {
    ChangeHouseView *changeHouseView = [[ChangeHouseView alloc] init];
    [self.navigationController pushViewController:changeHouseView animated:YES];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    uploadFace = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if ([uploadType isEqualToString:@"0"] == YES) {
            self.faceIv.image = editedImage;
            [self uploadFaceApi];
        }
        else if ([uploadType isEqualToString:@"1"] == YES)
        {
            [self uploadUserBgApi];
        }
    }];
}

- (void)uploadFaceApi
{
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
}

- (void)uploadUserBgApi
{
    //生成更换背景URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *changeBgSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserBgImg] params:param];
    
    NSString *changeBgUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserBgImg] params:param];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changeBgUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setTimeOutSeconds:30];
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:changeBgSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request addData:UIImageJPEGRepresentation(uploadFace, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestChangeUserBg:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"背景更新..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    if(self.navigationItem.rightBarButtonItem.enabled == NO)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
        [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        userInfo.photoFull = userPhoto;
        UserModel *userModel = [UserModel Instance];
        [userModel saveUserInfo:userInfo];
    }
}

- (void)requestChangeUserBg:(ASIHTTPRequest *)request
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
        NSString *userBg = [json objectForKey:@"data"];
        [self.mybgImageIv setImageWithURL:[NSURL URLWithString:userBg] placeholderImage:[UIImage imageNamed:@"my_bg"]];
        userInfo.bgImgFull = userBg;
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
