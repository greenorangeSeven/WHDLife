//
//  MapViewController.h
//  Sjdnbm
//
//  Created by tyh on 13-9-22.
//  Copyright (c) 2013年 tyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYBubbleView.h"
#import "KYPointAnnotation.h"
#import <sys/xattr.h>
#import "BMapKit.h"
#import "KxMenu.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, UITabBarDelegate>
{
    IBOutlet BMKMapView* _mapView;
    KYBubbleView *bubbleView;
    BMKAnnotationView *selectedAV;
    
    NSMutableArray *shops;
    
    BOOL isPinSelected;     //用于判断大头针是否被选中
    BMKLocationService* _locService;
    CLLocationCoordinate2D myCoor;
    
    int updateLoTime;
    MBProgressHUD *hud;
    
    UserInfo *userInfo;
}

@property (weak, nonatomic) UIView *frameView;

- (void)showBubble:(BOOL)show;

@end

