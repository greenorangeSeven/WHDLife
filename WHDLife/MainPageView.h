//
//  MainPageView.h
//  WHDLife
//
//  Created by Seven on 15-1-5.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface MainPageView : UIViewController<SGFocusImageFrameDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//生活信息
- (IBAction)lifeInfoAction:(id)sender;
//办事指南
- (IBAction)compassAction:(id)sender;
//物业信息
- (IBAction)coninforAction:(id)sender;
//便民黄页
- (IBAction)almanacAction:(id)sender;
//小区概况
- (IBAction)overviewAction:(id)sender;

//社区活动
- (IBAction)activityAction:(id)sender;
//房屋报修
- (IBAction)repairAction:(id)sender;
//物业通知
- (IBAction)noticeAction:(id)sender;
//投诉建议
- (IBAction)suitAction:(id)sender;
//水电缴费
- (IBAction)payFeeAction:(id)sender;

//快递及时通
- (IBAction)expressAction:(id)sender;
//精品推送
- (IBAction)commodityAction:(id)sender;
//团购信息
- (IBAction)tuanAction:(id)sender;
//房屋租售
- (IBAction)fwzsAction:(id)sender;
//装饰装修
- (IBAction)zszxAction:(id)sender;

@end
