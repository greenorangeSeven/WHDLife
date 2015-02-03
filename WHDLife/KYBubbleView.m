//
//  KYBubbleView.m
//  DrugRef
//
//  Created by chen xin on 12-6-6.
//  Copyright (c) 2012年 Kingyee. All rights reserved.
//

#import "KYBubbleView.h"

@implementation KYBubbleView

static const float kBorderWidth = 10.0f;
static const float kEndCapWidth = 30.0f;
static const float kMaxLabelWidth = 300.0f;

//@synthesize support;
@synthesize index;

/*
 初始化气泡view 和气泡 view中对所有元素
 先把气泡view 中对所有元素都添加到气泡view上之后，在别的方法中再对气泡view中对元素进行排列组合
 */
//此处应该是初始化气泡弹出后对矩形框
- (id)initWithFrame:(CGRect)frame
{
    //在这个方法里  self 就是一个透明对气泡view    气泡view中所有元素的属性全部在这里进行设置
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化标题lable
        nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [Tool getColorForMain];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:nameLabel];
        
        //初始化标题lable
        phoneLabel = [[UILabel alloc] init];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.font = [UIFont systemFontOfSize:14.0f];
        phoneLabel.numberOfLines = 0;
        [self addSubview:phoneLabel];
        
        routeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [routeButton setTitle:@"拨打电话" forState:UIControlStateNormal];
        [routeButton setTitleColor:[Tool getColorForMain] forState:UIControlStateNormal];
        [routeButton addTarget:self action:@selector(telphoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:routeButton];
        
        //气泡view的背景图片 － 被分为左边背景和右边背景两个部分
        UIImage *imageNormal, *imageHighlighted;
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *leftBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                 highlightedImage:imageHighlighted];
        leftBgd.tag = 11;
        
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *rightBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                  highlightedImage:imageHighlighted];
        rightBgd.tag = 12;
        
        [self addSubview:leftBgd];
        [self sendSubviewToBack:leftBgd];
        [self addSubview:rightBgd];
        [self sendSubviewToBack:rightBgd];
    }
    
    self.scrollEnabled = YES;
    
    return self;
}

/*
 生成气泡view和气泡view中的元素
 在此方法中对气泡 view以及其中对元素进行排列组合，呈现出我们想要对效果（即自定义气泡view）
 */
//显示矩形框  -  对气泡弹出后对矩形框内对数据进行初始化
- (BOOL)showFromRect:(CGRect)rect {
//    if (self.support == nil) {
//        return NO;
//    }
    
    //显示 标题label
    nameLabel.text = self.shop.shopName;
    nameLabel.frame = CGRectZero;   //暂时不定标题对尺寸
    [nameLabel sizeToFit];         //标题设置为自适应
    CGRect rect1 = nameLabel.frame;      //rect1为字符串对size 即(0,0,168,18)
    rect1.origin = CGPointMake(kBorderWidth, 8);  //(x,y) = (10,10)
    if (rect1.size.width > kMaxLabelWidth) {
        rect1.size.width = kMaxLabelWidth;
    }
    nameLabel.frame = rect1;   //（10,10,168，18）
    
    CGRect rectPro = rect1;
    NSString *phone = self.shop.phone1;
    if (phone != nil && ![phone isEqualToString:@""]) {
        phoneLabel.hidden = NO;
        phoneLabel.text = [NSString stringWithFormat:@"联系电话:%@", phone];
        phoneLabel.frame = CGRectZero;
        [phoneLabel sizeToFit];
        rectPro = phoneLabel.frame;
        phoneLabel.frame = CGRectMake(kBorderWidth, rect1.size.height + 5, rectPro.size.width + 10 , 40);
    }
    else
    {
        phoneLabel.hidden = YES;
    }
    
    routeButton.frame = CGRectMake(phoneLabel.frame.origin.x, phoneLabel.frame.origin.y + 30 , nameLabel.frame.size.width, 30);
    
    CGFloat longWidth = rect1.size.width > rectPro.size.width ? rect1.size.width : rectPro.size.width ;   //判定最大的宽度
    CGRect rect0 = self.frame;   //self 就是气泡view吧？  －－ rect0 代表气泡view的框架
    rect0.size.height = rect1.size.height + kBorderWidth + kEndCapWidth + 25 + 20;                                //气泡view的高
    rect0.size.width = longWidth + kBorderWidth + 10;   //气泡 view的宽
//    
//    UITapGestureRecognizer *popViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewClick:)];
//    [self addGestureRecognizer:popViewTap];

    //气泡view
    self.frame = rect0;     //rect0 果然是气泡view的显示框架
    //下面这个image 难道是气泡view的背景图片？——是的，详见气泡view初始化方法
    CGFloat halfWidth = rect0.size.width/2;      //气泡view 一半的宽度
    UIView *image = [self viewWithTag:11];       //［self viewWithTag:11］什么意思－详见气泡view初始化方法即知
    CGRect iRect = CGRectZero;
    iRect.size.width = halfWidth;
    iRect.size.height = rect0.size.height;
    image.frame = iRect;     //此处是什么意思——相当于设置这个元素显示对位置
    image = [self viewWithTag:12];  //此次是什么意思——详见气泡view初始化方法即知
    iRect.origin.x = halfWidth;    //x轴移动了整个气泡view的一半
    image.frame = iRect;       //让我不理解的是，image的frame为什么要一半一半地贴上图呢——为了气泡view 下面的小尾巴
    return YES;
}

- (void)telphoneAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.shop.phone1]];
    if (!phoneWebView) {
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

@end
