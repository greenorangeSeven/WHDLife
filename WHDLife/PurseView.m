//
//  PurseView.m
//  WHDLife
//
//  Created by Seven on 15-1-23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "PurseView.h"
#import "PurseCell.h"

@interface PurseView ()
{
    NSMutableArray *appArray;
}

@end

@implementation PurseView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appArray = [[NSMutableArray alloc] init];
    
    if ([Tool testAlipayInstall] == YES) {
        NSDictionary *alipay = [[NSDictionary alloc] initWithObjectsAndKeys:@"alipay", @"app", @"支付宝", @"appname", nil];
        [appArray addObject:alipay];
    }
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.frameView.frame.size.height);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([appArray count] == 0)
    {
        return 1;
    }
    else
    {
        return appArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([appArray count] > 0) {
        PurseCell *cell = [tableView dequeueReusableCellWithIdentifier:PurseCellIdentifier];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PurseCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[PurseCell class]]) {
                    cell = (PurseCell *)o;
                    break;
                }
            }
        }
        int row = [indexPath row];
        NSDictionary *app = [appArray objectAtIndex:row];
        cell.logoIv.image = [UIImage imageNamed:[app objectForKey:@"app"]];
        cell.nameLb.text = [app objectForKey:@"appname"];
        return cell;
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:NO andLoadOverString:@"暂无数据" andLoadingString:@"暂无数据" andIsLoading:NO];
    }
}
//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    NSDictionary *app = [appArray objectAtIndex:row];
    NSString *urlString = [NSString stringWithFormat:@"%@://",[app objectForKey:@"app"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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

@end
