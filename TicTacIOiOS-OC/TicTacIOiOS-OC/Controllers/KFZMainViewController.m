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
#import "KFZChatViewController.h"
#import "KFZChatModel.h"
#import "KFZSocketTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KFZFriendTableViewController.h"

@interface KFZMainViewController ()<UITableViewDelegate, UITableViewDataSource, KFZSocketToolDelegate>

@property (strong, nonatomic) NSMutableArray<KFZContact *> *dataSource;
@property (strong, nonatomic) KFZSocketTool *socketTool;

@end

@implementation KFZMainViewController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)addItem {
    UIBarButtonItem *friend = [[UIBarButtonItem alloc] initWithTitle:@"好友列表" style:UIBarButtonItemStylePlain target:self action:@selector(friend)];
    UIBarButtonItem *collMsgs = [[UIBarButtonItem alloc] initWithTitle:@"收藏消息" style:UIBarButtonItemStylePlain target:self action:@selector(collectionMessages)];
    self.navigationItem.rightBarButtonItems = @[friend,collMsgs];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp{
    self.navigationItem.title = @"会话列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tv.tableFooterView = [[UIView alloc] init];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.rowHeight = 45;
    
    self.socketTool = [KFZSocketTool socketTool];
    [self addItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getList];
    self.socketTool.delegate = self;
}

/**
 * 获取分类消息
 */
- (void)getCategoryMessages {
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"category" : @"CHAT",
                             @"page" : @(1),
                             @"pageSize" : @(5)
                             };
    [KFZNet getCategoryMessagesParam:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    /*
     token	签名	true	注：web用户传空值
     category	消息大类	true	[CHAT沟通类消息,CUSTOMER_SERVICE客服类消息,NOTICE通知类消息,DEAL交易类消息] ,多个分类已逗号分隔
     page	页码	true	分页页码
     pageSize	分页数	true
     */
}

/// 消息联系人接口
- (void)getList {
    [KFZNet getContactListSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *resultArray = [responseObject objectForKey:@"result"];
        self.dataSource = [KFZContact mj_objectArrayWithKeyValuesArray:resultArray];
        
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    KFZContact *model = self.dataSource [indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.clipsToBounds = YES;
//    cell.imageView.image = [UIImage imageNamed:@"icon"];
    cell.textLabel.text = model.contactNickname;
    NSString *unReadStr = [NSString localizedStringWithFormat:@"%lu",(unsigned long)model.unreadNum];
    if (model.unreadNum>99) {
        unReadStr = @"99+";
    }
    cell.detailTextLabel.text = model.unreadNum ? unReadStr : @"";

    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    KFZContact *model = self.dataSource [indexPath.row];
    if ( model.contactId != self.socketTool.loginInfo.userId ) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        [self deleteContact:indexPath];
    }
}

#pragma -mark 选择行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KFZChatViewController *vc = [[KFZChatViewController alloc] init];
    
    KFZContact *contact = self.dataSource[indexPath.item];
    contact.unreadNum = 0;
    [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    KFZChatModel *chatModel = [KFZChatModel chatModelWithBuddy:contact];
    
    vc.chatModel = chatModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark socket 代理事件
- (void)socketTool:(SocketIOClient *)socket unReadMessage:(NSArray *)array {
    NSDictionary *resultDic = [array firstObject][@"result"];
    NSDictionary *unreadListDic = resultDic[@"unreadList"];
    NSArray *keyArray = [unreadListDic allKeys];
    NSString *key = [keyArray firstObject];
    
    NSUInteger unreadNum = [unreadListDic[key] integerValue];
    NSUInteger userId = [key integerValue];
    
    int i = 0;
    for (; i<self.dataSource.count; i++) {
        KFZContact *contat = self.dataSource[i];
        if ( contat.contactId == userId ) {
            contat.unreadNum = unreadNum;
            // refresh
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }
    /*
     (
     {
         result =     {
             unreadList = {
                         201253 = 1;
                     };
             unreadNum = 1;
             userId = 1034285;
         };
         status = 1;
     }
     )
     */
}

/**
 * 联系人变动
 */
- (void)socketTool:(SocketIOClient *)socket contactChanged:(NSArray *)array {
    NSDictionary *resultDic = [array firstObject][@"result"];
    KFZContact *contact = [KFZContact mj_objectWithKeyValues:resultDic];
    [self.dataSource addObject:contact];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    [self.tv insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    /*
     (
     {
         result =     {
             contactId = 201253;
             contactNickname = "\U94f6\U8c61";
             isOnline = 0;
             lastMessageId = 1255;
             lastMsgDate = "2016-05-19 14:35:52";
             lastMsgDigest = "\U6211\U662f\U9501\U7709";
             lastMsgcreater = oneself;
             photo = "http://user.kfz.com/data/member_pic/1253/201253.jpg";
             userId = 80;
         };
         status = 1;
     }
     )
     */
}



#pragma -mark 导航栏 按钮 事件
- (void)friend {
    KFZFriendTableViewController *vc = [[KFZFriendTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionMessages {
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"page" : @"1",
                            @"pageSize" : @(COLLECTION_MESSAGE_PAGESIZE)
                            };
    [KFZNet getCollectionMessagesParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    /*
     token	签名	true	注：web用户传空值
     page	页码	true	分页页码
     pageSize	分页数	true	分页数
     isHistory	是否取历史消息
     */
}

/**
 *  删除联系人
 *  Param indexPath
 */
- (void)deleteContact:(NSIndexPath *)indexPath {
    // 删除联系人
    KFZContact *model = self.dataSource [indexPath.row];
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"contactId" : @(model.contactId)
                            };
    [KFZNet deleteContactParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"==============删除联系人失败%@",error);
    }];
    /*
     token	签名	true	注：web用户传空值
     contactId	联系人id
     */
}

@end























