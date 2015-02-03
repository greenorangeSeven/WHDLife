//
//  SuitResutCell.h
//  BBK
//
//  Created by Seven on 14-12-14.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface SuitResutCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
{
    NSArray *imageList;
    NSMutableArray *_photos;
}

@property (nonatomic, retain) NSMutableArray *photos;

@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *comtentLb;
@property (weak, nonatomic) IBOutlet UIView *resultImageFrameView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)loadRepairImage:(NSArray *)imageList;
@property (weak, nonatomic) UINavigationController *navigationController;
@end