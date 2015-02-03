//
//  SendExpressView.m
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "SendExpressView.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"
#import "ExpressCompany.h"

@interface SendExpressView ()
{
    UserInfo *userInfo;
    NSString *expressCompanyId;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSMutableArray *companyArray;

@property (strong, nonatomic) UIDatePicker *gatherDatePicker;
@property (strong, nonatomic) UIDatePicker *gatherTimeBucketPicker;
@property (nonatomic, strong) UIPickerView *companyPicker;

@end

@implementation SendExpressView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.frameView.frame.size.height);
    
    userInfo = [[UserModel Instance] getUserInfo];
    self.directionTf.text = [NSString stringWithFormat:@"%@%@%@%@%@", userInfo.defaultUserHouse.cellName, userInfo.defaultUserHouse.regionName, userInfo.defaultUserHouse.buildingName, userInfo.defaultUserHouse.unitName,userInfo.defaultUserHouse.numberName];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    self.gatherDatePicker = [[UIDatePicker alloc] init];
    self.gatherDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.gatherDatePicker addTarget:self
                             action:@selector(gatherDateChanged:)
                   forControlEvents:UIControlEventValueChanged];
    self.gatherDateTf.inputView = self.gatherDatePicker;
    self.gatherDateTf.delegate = self;
    
    self.companyPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.companyPicker.showsSelectionIndicator = YES;
    self.companyPicker.delegate = self;
    self.companyPicker.dataSource = self;
    self.expressCompanyTf.inputView = self.companyPicker;
    self.expressCompanyTf.delegate = self;
    
    [self getCompanyData];
}

- (void)getCompanyData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"数据加载..." andView:self.view andHUD:hud];
        //生成获取快递公司URL
        NSString *findExpressCompanyUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findAllExpressCompany] params:nil];
        [[AFOSCClient sharedClient]getPath:findExpressCompanyUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           self.companyArray = [Tool readJsonStrToExpressCompanyArray:operation.responseString];
                                           if ([self.companyArray count] > 0) {
                                               ExpressCompany * com = [self.companyArray objectAtIndex:0];
                                               self.expressCompanyTf.text = com.expressCompanyName;
                                               expressCompanyId = com.expressCompanyId;
                                           }
                                           if (hud) {
                                               [hud hide:YES];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (hud) {
                                           [hud hide:YES];
                                       }
                                       //如果是刷新
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.companyArray count];
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ExpressCompany * com = [self.companyArray objectAtIndex:row];
    return com.expressCompanyName;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ExpressCompany * com = [self.companyArray objectAtIndex:row];
    self.expressCompanyTf.text = com.expressCompanyName;
    expressCompanyId = com.expressCompanyId;
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
    [self.gatherDateTf resignFirstResponder];
    [self.expressCompanyTf resignFirstResponder];
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

-(void)gatherDateChanged:(id)sender
{
    NSDate *select = [self.gatherDatePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.gatherDateTf.text = dateAndTime;
}

- (IBAction)cameraAction:(id)sender {
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [cameraSheet showInView:self.view];
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

- (IBAction)submitAction:(id)sender {
    NSString *describeStr = self.describeTv.text;
    NSString *bournStr = self.bournTf.text;
    NSString *directionStr = self.directionTf.text;
    NSString *gatherDateStr = self.gatherDateTf.text;

    if ([describeStr length] == 0) {
        [Tool showCustomHUD:@"请输入描述" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([bournStr length] == 0) {
        [Tool showCustomHUD:@"请输入目的地" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([directionStr length] == 0) {
        [Tool showCustomHUD:@"请输入收件地" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([gatherDateStr length] == 0) {
        [Tool showCustomHUD:@"请选择收件时间" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }

    [self.submitBtn setEnabled:NO];
    
    //生成预约URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [param setValue:gatherDateStr forKey:@"starttime"];
    [param setValue:describeStr forKey:@"remark"];
    [param setValue:bournStr forKey:@"destination"];
    [param setValue:expressCompanyId forKey:@"expressCompanyId"];
    [param setValue:directionStr forKey:@"receivesPlace"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *addExpressoutInfoSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addExpressoutInfo] params:param];
    NSString *addExpressoutInfoUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addExpressoutInfo];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:addExpressoutInfoUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:addExpressoutInfoSign forKey:@"sign"];
    [request setPostValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [request setPostValue:gatherDateStr forKey:@"starttime"];
    [request setPostValue:describeStr forKey:@"remark"];
    [request setPostValue:bournStr forKey:@"destination"];
    [request setPostValue:expressCompanyId forKey:@"expressCompanyId"];
    [request setPostValue:directionStr forKey:@"receivesPlace"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    if (self.cameraIv.image) {
        [request addData:UIImageJPEGRepresentation(self.cameraIv.image, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    }
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"预约中..." andView:self.frameView andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.submitBtn.enabled == NO)
    {
        self.submitBtn.enabled = YES;
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
        self.submitBtn.enabled = YES;
        return;
    }
    else
    {
        self.cameraIv.image = nil;
        self.describeTv.text = @"";
        self.bournTf.text = @"";
        self.directionTf.text = @"";
        self.gatherDateTf.text = @"";
        self.submitBtn.enabled = YES;
        [Tool showCustomHUD:@"预约成功" andView:self.frameView  andImage:@"37x-Failure.png" andAfterDelay:2];
    }
}

@end
