//
//  ExpressFrameView.h
//  WHDLife
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GatherTableView.h"
#import "SendExpressView.h"
#import "HistoryExpressView.h"

@interface ExpressFrameView : UIViewController

@property (copy, nonatomic) NSString *present;

@property (weak, nonatomic) IBOutlet UIButton *item1Btn;
@property (weak, nonatomic) IBOutlet UIButton *item2Btn;
@property (weak, nonatomic) IBOutlet UIButton *item3btn;

- (IBAction)item1Action:(id)sender;
- (IBAction)item2Action:(id)sender;
- (IBAction)item3Action:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) GatherTableView *gatherView;
@property (strong, nonatomic) SendExpressView *sendView;
@property (strong, nonatomic) HistoryExpressView *historyView;

@end
