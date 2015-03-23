//
//  CreateSuitView.m
//  WHDLife
//
//  Created by Seven on 15-1-12.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "CreateSuitView.h"
#import "RepairImageCell.h"
#import "AMRatingControl.h"
#import "MySuitTableView.h"

@interface CreateSuitView ()
{
    NSMutableArray *repairImageArray;
    UserInfo *userInfo;
    int urgentDegree;
}

@end

@implementation CreateSuitView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"投诉建议";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 19)];
    [rBtn addTarget:self action:@selector(mySuitAction:) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setImage:[UIImage imageNamed:@"header_my"] forState:UIControlStateNormal];
    UIBarButtonItem *btnTel = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = btnTel;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.view.frame.size.height);
    
    //初始化拍照网格控件
    repairImageArray = [[NSMutableArray alloc] initWithCapacity:4];
    //    UIImage *myImage = [UIImage imageNamed:@"lucency"];
    //    [repairImageArray addObject:myImage];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[RepairImageCell class] forCellWithReuseIdentifier:RepairImageCellIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    //星级评价
    UIImage *dot, *star;
    dot = [UIImage imageNamed:@"star_nor"];
    star = [UIImage imageNamed:@"star_pro"];
    
    AMRatingControl *scoreControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    scoreControl.update = @selector(updateScoreRating:);
    scoreControl.targer = self;
    [scoreControl setRating:4];
    urgentDegree = 4;
    
    [self.starLb addSubview:scoreControl];
    
    self.addressTf.text = [NSString stringWithFormat:@"%@%@%@%@%@", userInfo.defaultUserHouse.cellName, userInfo.defaultUserHouse.regionName, userInfo.defaultUserHouse.buildingName, userInfo.defaultUserHouse.unitName,userInfo.defaultUserHouse.numberName];
    self.contactManTf.text = userInfo.regUserName;
}

- (void)mySuitAction:(id)sender
{
    MySuitTableView *mySuitsView = [[MySuitTableView alloc] init];
    mySuitsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySuitsView animated:YES];
}

- (void)updateScoreRating:(id)sender
{
    AMRatingControl *scoreControl = (AMRatingControl *)sender;
    urgentDegree = [scoreControl rating];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [repairImageArray count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepairImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RepairImageCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairImageCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[RepairImageCell class]]) {
                cell = (RepairImageCell *)o;
                break;
            }
        }
    }
    int row = [indexPath row];
    
    [cell.handleBtn addTarget:self action:@selector(picHandleAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.handleBtn.tag = row;
    //    if (row != [repairImageArray count] - 1) {
    //        [cell.handleBtn setImage:[UIImage imageNamed:@"pic_minus"] forState:UIControlStateNormal];
    //    }
    //    else
    //    {
    //        [cell.handleBtn setImage:[UIImage imageNamed:@"pic_add"] forState:UIControlStateNormal];
    //    }
    UIImage *repairImage = [repairImageArray objectAtIndex:row];
    cell.repairIv.image = repairImage;
    
    return cell;
}

- (IBAction)cameraAction:(id)sender {
    UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    cameraSheet.tag = 0;
    [cameraSheet showInView:self.view];
}

- (void)picHandleAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn) {
        int row = btn.tag;
        [repairImageArray removeObjectAtIndex:row];
        [self.collectionView reloadData];
        if ([repairImageArray count] >= 3) {
            self.cameraBtn.hidden = YES;
        }
        else
        {
            self.cameraBtn.hidden = NO;
        }
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(106, 189);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
        UIImage *smallImage = [self imageByScalingToMaxSize:portraitImg];
        //        [repairImageArray insertObject:smallImage atIndex:[repairImageArray count] -1];
        [repairImageArray addObject:smallImage];
        if ([repairImageArray count] >= 3) {
            self.cameraBtn.hidden = YES;
        }
        else
        {
            self.cameraBtn.hidden = NO;
        }
        [self.collectionView reloadData];
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
//拍照处理

- (IBAction)createAction:(id)sender {
    NSString *titleStr = self.titleTf.text;
    NSString *addressStr = self.addressTf.text;
    NSString *contactManStr = self.contactManTf.text;
    NSString *contactPhoneStr = self.contactPhoneTf.text;
    NSString *contentStr = self.contentTv.text;
    if ([titleStr length] == 0) {
        [Tool showCustomHUD:@"请输入主题" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([addressStr length] == 0) {
        [Tool showCustomHUD:@"请输入报修房屋" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([contactManStr length] == 0) {
        [Tool showCustomHUD:@"请输入联系人" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([contactPhoneStr length] == 0) {
        [Tool showCustomHUD:@"请输入联系电话" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if ([contentStr length] == 0) {
        [Tool showCustomHUD:@"请输入问题描述" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    self.createBtn.enabled = NO;
    
    //生成创建报修URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [param setValue:titleStr forKey:@"suitTitle"];
    [param setValue:contentStr forKey:@"suitContent"];
    [param setValue:contactManStr forKey:@"contactPerson"];
    [param setValue:contactPhoneStr forKey:@"contactPhone"];
    [param setValue:addressStr forKey:@"houseName"];
    [param setValue:[NSString stringWithFormat:@"%d", urgentDegree] forKey:@"urgentDegree"];
    NSString *createSuitSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addSuitWork] params:param];
    NSString *createSuitUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addSuitWork];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createSuitUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:createSuitSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
    [request setPostValue:titleStr forKey:@"suitTitle"];
    [request setPostValue:contentStr forKey:@"suitContent"];
    [request setPostValue:contactManStr forKey:@"contactPerson"];
    [request setPostValue:contactPhoneStr forKey:@"contactPhone"];
    [request setPostValue:addressStr forKey:@"houseName"];
    [request setPostValue:[NSString stringWithFormat:@"%d", urgentDegree] forKey:@"urgentDegree"];
    
    for (int i = 0 ; i < [repairImageArray count]; i++) {
        UIImage *repairImage = [repairImageArray objectAtIndex:i];
        [request addData:UIImageJPEGRepresentation(repairImage, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"pic%d", i]];
    }
    
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
        [Tool showCustomHUD:@"投诉创建完成" andView:self.parentView  andImage:@"37x-Failure.png" andAfterDelay:2];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
