//
//  CreateRepairView.h
//  WHDLife
//
//  Created by Seven on 15-1-9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateRepairView : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *parentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;
@property (weak, nonatomic) IBOutlet UITextField *contactManTf;
@property (weak, nonatomic) IBOutlet UITextView *contentTv;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
- (IBAction)createAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTf;
- (IBAction)cameraAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@end
