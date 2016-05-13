//
//  KFZMainViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZMainViewController.h"
#import "MJExtension.h"
#import "KFZContact.h"
#import "ViewController.h"
#import "KFZUserInfo.h"


@interface KFZMainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation KFZMainViewController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tv.tableFooterView = [[UIView alloc] init];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.rowHeight = 45;
    [self getList];
    [KFZUserInfo userInfo];
}

/// 消息联系人接口
- (void)getList {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CONTACTLIST];
    NSDictionary *params = @{
                             @"token" : TOKEN
                             };
    [KFZNet POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSArray *resultArray = [responseObject objectForKey:@"result"];
        for (NSDictionary *d in resultArray) {
            KFZContact *model = [KFZContact mj_objectWithKeyValues:d];
            [self.dataSource addObject:model];
        }
        [self.tv reloadData];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma -mark tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"contact_cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    KFZContact *model = self.dataSource [indexPath.row];
    cell.textLabel.text = model.contactNickname;
    cell.detailTextLabel.text = model.lastMsgDigest;
    
    return cell;
}
#pragma -mark 选择行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewController *vc = [[ViewController alloc] init];
    KFZContact *model = self.dataSource[indexPath.row];
    
    vc.receiverNum = model.contactId;
    vc.receiverNickname = model.contactNickname;
    vc.receiverPhoto = model.photo;
    
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
}



@end























