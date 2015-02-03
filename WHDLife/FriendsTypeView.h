//
//  FriendsTypeView.h
//  WHDLife
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsPageView.h"
#import "FriendsAddView.h"

@interface FriendsTypeView : UIView
+ (instancetype) instance;

@property (weak, nonatomic) FriendsPageView *frendsPage;
@property (weak, nonatomic) FriendsAddView *addView;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIView *myfocusView;

- (IBAction)typeAction:(id)sender;
- (void)isAddView:(BOOL)iS;
@end
