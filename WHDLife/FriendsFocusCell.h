//
//  BBSTableCell.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface FriendsFocusCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
{
}

@property (weak, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *photos;

@property (retain, nonatomic) NSArray *imgArray;

@property (weak, nonatomic) IBOutlet UIView *bottom_line;

@property (weak, nonatomic) IBOutlet UIImageView *facePic;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;

@end
