//
//  OverviewFrameView.h
//  WHDLife
//
//  Created by Seven on 15-1-26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommDetailView.h"
#import "MapViewController.h"

@interface OverviewFrameView : UIViewController

@property (strong, nonatomic) CommDetailView *xqjjView;
@property (strong, nonatomic) MapViewController *xqdtView;

@property (weak, nonatomic) IBOutlet UIButton *xqjjBtn;
@property (weak, nonatomic) IBOutlet UIButton *xqdtBtn;

@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)xqjjAction:(id)sender;
- (IBAction)xqdtAction:(id)sender;

@end
