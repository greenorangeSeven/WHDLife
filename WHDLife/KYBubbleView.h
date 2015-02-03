//
//  KYBubbleView.h
//  DrugRef
//
//  Created by chen xin on 12-6-6.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PeripheralShop.h"

@interface KYBubbleView : UIScrollView {   //UIView是气泡view的本质
    UILabel         *nameLabel;
    UILabel         *phoneLabel;
    UILabel         *goLabel;
    UIButton        *routeButton;
    NSUInteger      index;
    UIWebView *phoneWebView;
}

@property CLLocationCoordinate2D myCoor;
@property (nonatomic, retain) PeripheralShop *shop;
@property (nonatomic, retain) UINavigationController *navigationController;
@property NSUInteger index;

- (BOOL)showFromRect:(CGRect)rect;

@end
