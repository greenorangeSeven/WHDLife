//
//  ActivityDetailView.h
//  WHDLife
//
//  Created by Seven on 15-1-8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIViewController

@property (copy, nonatomic) NSString *activityId;

@property (weak, nonatomic) IBOutlet UIImageView *ImageIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *contactManLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *cutoffLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *countUserLb;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
- (IBAction)joinAction:(id)sender;

@end
