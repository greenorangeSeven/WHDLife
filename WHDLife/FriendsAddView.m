//
//  FriendsAddView.m
//  WHDLife
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsAddView.h"
#import "FriendsTypeView.h"

@interface FriendsAddView ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *titleBtn;
    FriendsTypeView *friendsTypeView;
    UIImage *topicImg;
    BOOL isShowedPop;
    int typeId;
    UserInfo *userInfo;
}

@end

@implementation FriendsAddView

- (void)viewDidLoad {
    [super viewDidLoad];
    typeId = 0;
    userInfo = [[UserModel Instance] getUserInfo];
    UIButton *btnLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    [btnLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLabel setTitle:@"社区分享" forState:UIControlStateNormal];
    btnLabel.backgroundColor = [UIColor clearColor];
    [btnLabel.imageView setContentMode:UIViewContentModeCenter];
    [btnLabel setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
    [btnLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnLabel addTarget:self action:@selector(showFriendsTypePopup:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn = btnLabel;
    self.navigationItem.titleView = btnLabel;
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 19)];
    [rBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    friendsTypeView = [FriendsTypeView instance];
    friendsTypeView.addView = self;
    [friendsTypeView setUserInteractionEnabled: YES];
    
    [Tool roundTextView:self.topicText andBorderWidth:1.0f andCornerRadius:5.0f];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picHandleAction:)];
    [self.imgTopic addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [friendsTypeView isAddView:YES];
}

- (void)showFriendsTypePopup:(UIButton *)sender
{
    if(isShowedPop)
    {
        [sender setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
        [sender setEnabled: NO];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
            
        } completion:^(BOOL finished) {
            isShowedPop = NO;
            [sender setEnabled: YES];
        }];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"friends_arrow_top"] forState:UIControlStateNormal];
        [sender setEnabled: NO];
        friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
        [self.view addSubview:friendsTypeView];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, -100, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
        } completion:^(BOOL finished) {
            isShowedPop = YES;
            [sender setEnabled: YES];
        }];
    }
}

- (void)reloadTopicByType:(int)type andTitle :(NSString *)title
{
    if(isShowedPop)
    {
        [titleBtn setImage:[UIImage imageNamed:@"friends_arrow_bottom"] forState:UIControlStateNormal];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [titleBtn setEnabled: NO];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            friendsTypeView.frame = CGRectMake(0, -friendsTypeView.frame.size.height, friendsTypeView.frame.size.width, friendsTypeView.frame.size.height);
            
        } completion:^(BOOL finished)
         {
             isShowedPop = NO;
             [titleBtn setEnabled: YES];
             //如果当前显示的类别跟选择的类别相同则不需要刷新
             if(typeId == type)
             {
                 return;
             }
             
             typeId = type - 2;
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)picHandleAction:(id)sender
{
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照", @"从相册中选取", nil];
        cameraSheet.tag = 0;
        [cameraSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
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
        else if (buttonIndex == 1) {
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
        topicImg = [self imageByScalingToMaxSize:portraitImg];
        [self.imgTopic setImage:topicImg];
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

- (void)pushAction:(id)sender
{
    NSString *contentStr = self.topicText.text;
    if ([contentStr length] == 0)
    {
        [Tool showCustomHUD:@"请输入内容" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:[NSString stringWithFormat:@"%i",typeId] forKey:@"typeId"];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [param setValue:contentStr forKey:@"content"];
    NSString *createRepairSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicInfo] params:param];
    
    //生成创建帖子URL
    NSString *createRepairUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicInfo];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createRepairUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createRepairSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:[NSString stringWithFormat:@"%i",typeId] forKey:@"typeId"];
    [request setPostValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [request setPostValue:contentStr forKey:@"content"];
//    
//    for (int i = 0 ; i < [repairImageArray count] - 1; i++) {
//        UIImage *repairImage = [repairImageArray objectAtIndex:i];
        [request addData:UIImageJPEGRepresentation(topicImg, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"pic%d", 1]];
//    }
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"创建中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
}

- (void)requestCreate:(ASIHTTPRequest *)request
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
        return;
    }
    else
    {
        [Tool showCustomHUD:@"创建完成" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyFriends" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
