//
//  MapViewController.m
//  Sjdnbm
//
//  Created by tyh on 13-9-22.
//  Copyright (c) 2013年 tyh. All rights reserved.
//

#import "MapViewController.h"
#import "PeripheralShop.h"

@implementation MapViewController

static CGFloat kTransitionDuration = 0.45f;

- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.frameView];
    [Tool showHUD:@"地图加载" andView:self.view andHUD:hud];
    
    updateLoTime = 0;
    isPinSelected = NO;   //new
    
    _mapView.zoomLevel = 15;
    _locService = [[BMKLocationService alloc]init];
    bubbleView = [[KYBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    bubbleView.hidden = NO;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.frameView.frame.size.height);
    
//    _mapView.frame = CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height + 20);
     [self initMapsData];
//    [self startLocation];
   
}

-(void)initMapsData{
    //生成获取周边商家URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    NSString *peripheralShopUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_peripheralShop] params:param];
    
    if ([UserModel Instance].isNetworkRunning) {
        [[AFOSCClient sharedClient]getPath:peripheralShopUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           shops = [Tool readJsonStrToPeripheralShopArray:operation.responseString];
                                           
                                           PeripheralShop *shop = [shops objectAtIndex:0];
                                           
                                           CLLocationCoordinate2D coor;
                                           coor.longitude = shop.longitude;
                                           coor.latitude = shop.latitude;
                                           [_mapView setCenterCoordinate:coor animated:YES];
                                           
                                           //添加PointAnnotation
                                           for (int i = 0; i < [shops count]; i++) {
                                               PeripheralShop *temp =[shops objectAtIndex:i];
                                               
                                               KYPointAnnotation* item = [[KYPointAnnotation alloc]init];
                                               item.tag = i;
                                               CLLocationCoordinate2D coor;
                                               coor.longitude = temp.longitude;
                                               coor.latitude = temp.latitude;
                                               item.coordinate = coor;
                                               item.title = temp.shopName;
                                               [_mapView addAnnotation:item];   //会触发委托方法
                                           }
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"地图获取出错");
                                       if (hud != nil) {
                                           [hud hide:YES];
                                       }
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    _mapView.delegate = nil;
}

- (void)changeBubblePosition {
    if (selectedAV) {
        CGRect rect = selectedAV.frame;
        CGPoint center;
        center.x = rect.origin.x + rect.size.width/2;
        center.y = rect.origin.y - bubbleView.frame.size.height/2 + 8;
        bubbleView.center = center;
    }
}

#ifdef Debug

#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#	define DLog(...)

#endif

#pragma mark 标注（应该就是大头针吧）
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    DLog(@"生成标注view");
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
    if (annotationView == nil)
    {
        KYPointAnnotation *ann;
        if ([annotation isKindOfClass:[KYPointAnnotation class]]) {
            ann = annotation;
        }else{
            return annotationView ;
        }
        NSUInteger tag = ann.tag;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"AnnotationView-%i", tag];
        PeripheralShop *support = [shops objectAtIndex:tag];
        
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed;
        annotationView.canShowCallout = NO;//使用自定义bubble
        
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
        //        // 设置可拖拽
        //		((BMKPinAnnotationView*)annotationView).draggable = YES;
        
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        //把大头针换成别的图片
        
        
        annotationView.image = [UIImage imageNamed:@"map_dlife_p"];
        
    }
    return annotationView ;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"选中标注");
    isPinSelected = YES;
    //CGPoint point = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        //CGRect rect = selectedAV.frame;
        DLog(@"annotationPoint:x=%.1f, y=%.1f", point.x, point.y);
#endif
        selectedAV = view;
        if (bubbleView.superview == nil) {
            //bubbleView加在BMKAnnotationView的superview(UIScrollView)上,且令zPosition为1
            [view.superview addSubview:bubbleView];  //为大头针添加自定义对气泡view
            bubbleView.layer.zPosition = 1;
        }try {
            bubbleView.shop = [shops objectAtIndex:[(KYPointAnnotation*)view.annotation tag]];  //数据全部在数据字典中
            bubbleView.myCoor = myCoor;
            bubbleView.navigationController = self.navigationController;
            //      [self showBubble:YES];//先移动地图，完成后再显示气泡
        } catch (NSException *exception) {
            
        }
    }
    else {
        selectedAV = nil;
    }
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    DLog(@"取消选中标注");
    isPinSelected = NO;
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        [self showBubble:NO];
    }
}

#pragma mark 区域改变
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (selectedAV) {
        bubbleView.hidden = YES;
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        //CGRect rect = selectedAV.frame;
        DLog(@"x=%.1f, y= %.1f", point.x, point.y);
#endif
    }
    DLog(@"地图区域即将改变");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (selectedAV) {
        if (isPinSelected) {    //只有当大头针被选中时的区域改变才会显示气泡
            [self showBubble:YES];       //modify 地图区域改变  - 原代码是没有注释的
            [self changeBubblePosition];
        }
#ifdef Debug
        CGPoint point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:selectedAV.superview];
        DLog(@"x=%.1f, y= %.1f", point.x, point.y);
#endif
    }
    DLog(@"地图区域改变完成");
}


#pragma mark show bubble animation
- (void)bounce4AnimationStopped{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView commitAnimations];
}


- (void)bounce3AnimationStopped{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)showBubble:(BOOL)show {
    if (show) {
        [bubbleView showFromRect:selectedAV.frame];
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        bubbleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        bubbleView.hidden = NO;
        [UIView commitAnimations];
    }
    else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        bubbleView.hidden = YES;
        [UIView commitAnimations];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    selectedAV = nil;
    //    [self startLocation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

-(void)startLocation
{
    NSLog(@"进入基本定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    //    如果经纬度大于0表单表示定位成功,并成功定位三次，停止定位（一次不能刷新地图，致使地图空白）
    if (userLocation.location.coordinate.latitude > 0 && updateLoTime == 3) {
        myCoor = userLocation.location.coordinate;
        [_locService stopUserLocationService];
        if (hud != nil) {
            [hud hide:YES];
        }
    }
    updateLoTime ++;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end