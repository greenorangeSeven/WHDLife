//
//  GatherSelectView.m
//  WHDLife
//
//  Created by Seven on 15-1-15.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "GatherSelectView.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

@interface GatherSelectView ()
{
    NSString *selectTYpe;
    int selectTimeTypeValue;
    UserInfo *userInfo;
}

@property (nonatomic, strong) NSArray *timeBucketArray;

@property (strong, nonatomic) UIDatePicker *gatherDatePicker;
@property (strong, nonatomic) UIPickerView *gatherTimeBucketPicker;


@end

@implementation GatherSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"快递收件方式";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    userInfo = [[UserModel Instance] getUserInfo];
    selectTYpe = @"1";
    selectTimeTypeValue = 0;
    
    self.addressTf.text = [NSString stringWithFormat:@"%@%@%@%@%@", userInfo.defaultUserHouse.cellName, userInfo.defaultUserHouse.regionName, userInfo.defaultUserHouse.buildingName, userInfo.defaultUserHouse.unitName,userInfo.defaultUserHouse.numberName];
    
    self.gatherDatePicker = [[UIDatePicker alloc] init];
    self.gatherDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.gatherDatePicker addTarget:self
                              action:@selector(gatherDateChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.dateTf.inputView = self.gatherDatePicker;
    self.dateTf.delegate = self;
    
    self.timeBucketArray = @[@"10:00~12:00", @"12:00~14:00", @"14:00~16:00", @"16:00~18:00", @"18:00~20:00", @"20:00~22:00"];
    self.gatherTimeBucketPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.gatherTimeBucketPicker.showsSelectionIndicator = YES;
    self.gatherTimeBucketPicker.delegate = self;
    self.gatherTimeBucketPicker.dataSource = self;
    self.timeQuantumTf.inputView = self.gatherTimeBucketPicker;
    self.timeQuantumTf.delegate = self;
    
    NSString *gatherTimeStr = (NSString *)[self.timeBucketArray objectAtIndex:0];
    self.timeQuantumTf.text = gatherTimeStr;
    
    NSDate *select = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.dateTf.text = dateAndTime;
}

- (UIToolbar *)keyboardToolBar:(int)fieldIndex
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.tag = fieldIndex;
    doneButton.title = @"完成";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.target = self;
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    return toolBar;
}

- (void)doneClicked:(UITextField *)sender
{
    [self.dateTf resignFirstResponder];
    [self.timeQuantumTf resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

-(void)gatherDateChanged:(id)sender
{
    NSDate *select = [self.gatherDatePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    self.dateTf.text = dateAndTime;
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.timeBucketArray count];
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *gatherTimeStr = (NSString *)[self.timeBucketArray objectAtIndex:row];
    return gatherTimeStr;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectTimeTypeValue= row;
    NSString *gatherTimeStr = (NSString *)[self.timeBucketArray objectAtIndex:row];
    self.timeQuantumTf.text = gatherTimeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)type0Action:(id)sender {
    selectTYpe = @"0";
    [self.type0Btn setImage:[UIImage imageNamed:@"type_on"] forState:UIControlStateNormal];
    [self.type1Btn setImage:[UIImage imageNamed:@"type_off"] forState:UIControlStateNormal];
    self.dateTf.enabled = NO;
    self.timeQuantumTf.enabled = NO;
}

- (IBAction)type1Action:(id)sender {
    selectTYpe = @"1";
    [self.type0Btn setImage:[UIImage imageNamed:@"type_off"] forState:UIControlStateNormal];
    [self.type1Btn setImage:[UIImage imageNamed:@"type_on"] forState:UIControlStateNormal];
    self.dateTf.enabled = YES;
    self.timeQuantumTf.enabled = YES;
}

- (IBAction)submitAction:(id)sender {
    [self.submitBtn setEnabled:NO];
    //生成收件URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.expressId forKey:@"expressId"];
    [param setValue:selectTYpe forKey:@"receivesTypeId"];
    if ([selectTYpe isEqualToString:@"1"] == YES) {
        [param setValue:self.dateTf.text forKey:@"appointmentTime"];
        [param setValue:[NSString stringWithFormat:@"%d", selectTimeTypeValue] forKey:@"timeId"];
    }
    NSString *setReceiveTypeSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_setReceiveType] params:param];
    NSString *setReceiveTypeUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_setReceiveType];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:setReceiveTypeUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    
    [request setPostValue:AccessId forKey:@"accessId"];
    [request setPostValue:setReceiveTypeSign forKey:@"sign"];
    [request setPostValue:self.expressId forKey:@"expressId"];
    [request setPostValue:selectTYpe forKey:@"receivesTypeId"];
    if ([selectTYpe isEqualToString:@"1"] == YES) {
        [request setPostValue:self.dateTf.text forKey:@"appointmentTime"];
        [request setPostValue:[NSString stringWithFormat:@"%d", selectTimeTypeValue] forKey:@"timeId"];
    }
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestOrder:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"提交中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
        
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(self.submitBtn.enabled == NO)
    {
        self.submitBtn.enabled = YES;
    }
}
- (void)requestOrder:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:[[json objectForKey:@"header"] objectForKey:@"msg"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        self.submitBtn.enabled = YES;
        return;
    }
    else
    {
        [Tool showCustomHUD:@"提交成功" andView:self.parentView  andImage:@"37x-Failure.png" andAfterDelay:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RefreshGatherTable object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
