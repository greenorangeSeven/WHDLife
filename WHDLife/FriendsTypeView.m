//
//  FriendsTypeView.m
//  WHDLife
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FriendsTypeView.h"

@interface FriendsTypeView ()
{
    UIView *currentView;
    NSString *currentTitle;
}

@end

@implementation FriendsTypeView

+ (instancetype)instance
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FriendsTypeView" owner:nil options:nil];
    for (NSObject *o in objects) {
        if ([o isKindOfClass:[FriendsTypeView class]])
        {
            return (FriendsTypeView *)o;
        }
    }
    
    return nil;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        currentView = self.allView;
    }
    
    return self;
}

- (void)isAddView:(BOOL)iS
{
    if(iS)
    {
        self.allView.hidden = YES;
        self.myfocusView.hidden = YES;
        [self setNeedsLayout];
    }
}

- (IBAction)typeAction:(UIButton *)sender
{
    NSString *title = nil;
    if(currentView == sender.superview)
    {
        [self.frendsPage reloadTopicByType:sender.tag andTitle:currentTitle];
        return;
    }
    
    for(UIView *view in sender.superview.subviews)
    {
        if(view.tag == 10)
        {
            UIImageView *imageView = (UIImageView *)view;
            [imageView setImage:[UIImage imageNamed:@"friends_current"]];
        }
        else if(view.tag == 11)
        {
            UILabel *label = (UILabel *)view;
            title = label.text;
        }
    }
    
    if(currentView)
    {
        for(UIView *view in currentView.subviews)
        {
            if(view.tag == 10)
            {
                UIImageView *imageView = (UIImageView *)view;
                [imageView setImage:[UIImage imageNamed:@"friends_add"]];
            }
        }
    }
    currentView = sender.superview;
    currentTitle = title;
    if(self.frendsPage)
    {
        [self.frendsPage reloadTopicByType:sender.tag andTitle:title];
    }
    else if(self.addView)
    {
        [self.addView reloadTopicByType:sender.tag andTitle:title];
    }
}
@end
