//
//  RepairResultView.h
//  WHDLife
//
//  Created by Seven on 15-1-11.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairResultView : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) NSString *repairWorkId;

@property (nonatomic, strong) UIView *parentView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UIButton *sunmitBtn;

- (IBAction)submitAction:(id)sender;

@end
