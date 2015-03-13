//
//  ActivityInitiateView.m
//  WHDLife
//
//  Created by Seven on 15-1-7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ActivityInitiateView.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface ActivityInitiateView ()
{
    UIImage *uploadImage;
    UserInfo *userInfo;
}

@property (strong, nonatomic) UIDatePicker *startTimePicker;
@property (strong, nonatomic) UIDatePicker *endTimePicker;
@property (strong, nonatomic) UIDatePicker *cutOffTimePicker;

@end

@implementation ActivityInitiateView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"创建活动";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);

    self.startTimePicker = [[UIDatePicker alloc] init];
    self.startTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.startTimePicker addTarget:self
                             action:@selector(startTimeChanged:)
                   forControlEvents:UIControlEventValueChanged];
    self.startTimeTf.inputView = self.startTimePicker;
    self.startTimeTf.delegate = self;
    
    self.endTimePicker = [[UIDatePicker alloc] init];
    self.endTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.endTimePicker addTarget:self
                           action:@selector(endTimeChanged:)
                 forControlEvents:UIControlEventValueChanged];
    self.endTimeTf.inputView = self.endTimePicker;
    self.endTimeTf.delegate = self;
    
    self.cutOffTimePicker = [[UIDatePicker alloc] init];
    self.cutOffTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.cutOffTimePicker addTarget:self
                              action:@selector(cutOffTimeChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.cutOffTimeTf.inputView = self.cutOffTimePicker;
    self.cutOffTimeTf.delegate = self;
    
    NSDate *nowDate = [NSDate date];
    self.startTimePicker.minimumDate = nowDate;
}

- (UIToolbar *)keyboardToolBar:(int)fieldIndex
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.tag = fieldIndex;
    doneButton.title = @"完成";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.target = self;
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    return toolBar;
}

- (void)doneClicked:(UITextField *)sender
{
    [self.startTimeTf resignFirstResponder];
    [self.endTimeTf resignFirstResponder];
    [self.cutOffTimeTf resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

-(void)startTimeChanged:(id)sender
{
    NSDate *select = [self.startTimePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.startTimeTf.text = dateAndTime;
    
    //清空结束时间、截止时间，并设定时间范围
    self.endTimeTf.text = @"";
    self.cutOffTimeTf.text = @"";
    self.endTimePicker.minimumDate = select;
    self.cutOffTimePicker.maximumDate = select;
}

-(void)endTimeChanged:(id)sender
{
    NSDate *select = [self.endTimePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.endTimeTf.text = dateAndTime;
}

-(void)cutOffTimeChanged:(id)sender
{
    NSDate *select = [self.cutOffTimePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.cutOffTimeTf.text = dateAndTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cameraAction:(id)sender {
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [cameraSheet showInView:self.view];
}

- (IBAction)createAction:(id)sender {
    NSString *titleStr = self.titleTf.text;
    NSString *addressStr = self.addressTf.text;
    NSString *contactManStr = self.contactManTf.text;
    NSString *telphoneStr = self.telphoneTf.text;
    NSString *cutOffTimeStr = self.cutOffTimeTf.text;
    NSString *startTimeStr = self.startTimeTf.text;
    NSString *endTimeStr = self.endTimeTf.text;
    NSString *totalStr = self.totalTf.text;
    NSString *contentStr = self.contentTv.text;
    if ([titleStr length] == 0) {
        [Tool showCustomHUD:@"请输入主题" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([addressStr length] == 0) {
        [Tool showCustomHUD:@"请输入活动地点" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([contactManStr length] == 0) {
        [Tool showCustomHUD:@"请输入联系人" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([telphoneStr length] == 0) {
        [Tool showCustomHUD:@"请输入联系电话" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([cutOffTimeStr length] == 0) {
        [Tool showCustomHUD:@"请选择截止时间" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([startTimeStr length] == 0) {
        [Tool showCustomHUD:@"请选择开始时间" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([endTimeStr length] == 0) {
        [Tool showCustomHUD:@"请选择结束时间" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([totalStr length] == 0) {
        [Tool showCustomHUD:@"请输入人数上限" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([contentStr length] == 0) {
        [Tool showCustomHUD:@"请输入活动详情" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (uploadImage == nil) {
        [Tool showCustomHUD:@"请上传图片" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    [self.createBtn setEnabled:NO];
    
    //生成创建活动URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:titleStr forKey:@"activityName"];
    [param setValue:telphoneStr forKey:@"phone"];
    [param setValue:startTimeStr forKey:@"starttime"];
    [param setValue:endTimeStr forKey:@"endtime"];
    [param setValue:contentStr forKey:@"content"];
    [param setValue:addressStr forKey:@"address"];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [param setValue:totalStr forKey:@"totalCount"];
    [param setValue:contactManStr forKey:@"contactMan"];
    [param setValue:cutOffTimeStr forKey:@"cutoffTime"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *createActivitySign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addActivityForApp] params:param];
    NSString *createActivityUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addActivityForApp];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createActivityUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createActivitySign forKey:@"sign"];
    [request setPostValue:titleStr forKey:@"activityName"];
    [request setPostValue:telphoneStr forKey:@"phone"];
    [request setPostValue:startTimeStr forKey:@"starttime"];
    [request setPostValue:endTimeStr forKey:@"endtime"];
    [request setPostValue:contentStr forKey:@"content"];
    [request setPostValue:addressStr forKey:@"address"];
    [request setPostValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    [request setPostValue:totalStr forKey:@"totalCount"];
    [request setPostValue:contactManStr forKey:@"contactMan"];
    [request setPostValue:cutOffTimeStr forKey:@"cutoffTime"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request addData:UIImageJPEGRepresentation(uploadImage, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    
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
    if(self.createBtn.enabled == NO)
    {
        self.createBtn.enabled = YES;
    }
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
        self.createBtn.enabled = YES;
        return;
    }
    else
    {
        [Tool showCustomHUD:@"活动创建完成" andView:self.parentView  andImage:@"37x-Failure.png" andAfterDelay:2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0)
    {
        if (buttonIndex == 0)
        {
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
        } else if (buttonIndex == 1)
        {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable])
            {
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
        self.cameraIv.image = portraitImg;
        uploadImage = portraitImg;
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

#pragma mark 缩放图片
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
