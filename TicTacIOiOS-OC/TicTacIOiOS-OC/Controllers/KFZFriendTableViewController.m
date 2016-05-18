//
//  KFZFriendTableViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/18.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZFriendTableViewController.h"
#import "KFZSocketTool.h"
#import "MJExtension.h"
#import "KFZFriend.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KFZFriendTableViewController ()
@property (assign, nonatomic) NSUInteger page;

@end

@implementation KFZFriendTableViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)addItem {
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
//    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector()];
    self.navigationItem.rightBarButtonItems = @[add];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    
    
    self.socketTool = [KFZSocketTool socketTool];
    [self getFriendList];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 45;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addItem];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_Id = @"friend_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_Id];
    }
    //
    KFZFriend *model = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = model.friendNickname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self deleteFriend:indexPath];
    }
}

#pragma -mark 好友相关

/// 取得好友列表
- (void)getFriendList {
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"page" : @(self.page),
                            @"pageSize" : @(10)
                            };
    [KFZNet getFriendListParam:param success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSDictionary *pagerDic = responseObject[@"pager"];
        self.page = [pagerDic[@"pageCurr"] integerValue];
        NSArray *resultArray = responseObject[@"result"];
        NSMutableArray *friendArray = [KFZFriend mj_objectArrayWithKeyValuesArray:resultArray];
        [self.dataSource addObjectsFromArray:friendArray];
        [self.tableView reloadData];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"==========%@",error);
    }];
    /*
     token	签名	true	注：web用户传空值
     page	页码	true	分页页码
     pageSize	分页数
     */
}


#pragma -mark 导航栏 按钮  事件
- (void)addFriend {
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"friendId" : @(201253),
                            @"friendNickname" : @"银象"
                            };
    [KFZNet addFriendParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.page = 1;
        self.dataSource = nil;
        [self getFriendList];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"====================== add friend faile,%@",error);
    }];
    /*
     token	签名	true	注：web用户传空值
     friendId	好友id	true	``
     friendNickname	好友昵称
     */
}
- (void)deleteFriend:(NSIndexPath *)indexPath {
    KFZFriend *model = self.dataSource[indexPath.row];
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"friendId" : @(model.friendId)
                            };
    [KFZNet deleteFriendParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"====================== delete friend faile,%@",error);
    }];
    /*
     token	签名	true	注：web用户传空值
     friendId	好友id
     */
}

@end










