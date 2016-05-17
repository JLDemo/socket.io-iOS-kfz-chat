//
//  KFZChatViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/17.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZChatViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"


@interface KFZChatViewController ()

@end

@implementation KFZChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefresh];
}

- (void)addRefresh {
    typeof(self) ws;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.collectionView.mj_header endRefreshing];
        });
    }];
    
}

#pragma -mark socket 的代理事件
- (void)socketTool:(SocketIOClient *)socket buddyIsTyping:(NSArray *)array {
    [self showTyping];
}
- (void)socketTool:(SocketIOClient *)socket getBuddyMessage:(NSArray *)array {
    NSDictionary *resultDic = [[array firstObject] objectForKey:@"result"];
    KFZMessage *message = [KFZMessage mj_objectWithKeyValues:resultDic];
    [self.chatModel.messages addObject:message];
    [self finishReceivingMessageAnimated:YES];
}
- (void)socketTool:(SocketIOClient *)socket sendMessageSuccess:(NSArray *)array {
    NSLog(@"sub class must write this method");
}
#pragma -mark 输入工具条点击事件
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    KFZMessage *message = [KFZMessage messageWithSenderId:self.senderId displayName:self.senderDisplayName text:text];
    message.msgContent = text;
    message.sender = [senderId integerValue];
    message.senderNickname = senderDisplayName;
    [self.chatModel.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}
- (void)didPressAccessoryButton:(UIButton *)sender {
}
@end





























