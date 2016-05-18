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
#import "KFZSocketTool.h"


@interface KFZChatViewController ()

@end

@implementation KFZChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self scrollToBottomAnimated:YES];
}

// 收到发送消息的反馈(不一定成功)
- (void)socketTool:(SocketIOClient *)socket sendMessageSuccess:(NSArray *)array {
    NSDictionary *resultDic = [[array firstObject] objectForKey:@"result"];
    
    KFZMessage *message = [KFZMessage mj_objectWithKeyValues:resultDic];
    [self.chatModel.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    [self scrollToBottomAnimated:YES];
    /*
     (
         {
             result =     {
                 clientId = 9640084527bd776bd0aa99dbdaab6c55;
                 clientMsgId = "1463468111.058251";
                 messageId = 329;
                 msgContent = "\U6211\U6536\U5230";
                 receiver = 201253;
                 receiverNickname = "\U94f6\U8c61";
                 sendTime = "2016-05-17 14:55:10";
                 sender = 1034285;
                 senderNickname = "%E4%B8%9C%E5%8C%97%E7%8B%A0%E4%BA%BA1";
             };
             status = 1;
         }
     )
     */
}
// 消息发送失败的通知
- (void)socketTool:(SocketIOClient *)socket sendMessageStateNotice:(NSArray *)array {
    NSDictionary *resultDic = [array firstObject][@"result"];
    NSUInteger messageId = [resultDic[@"messageId"] integerValue];
    for (int i=self.chatModel.messages.count - 1; i>=0; i--) {
        KFZMessage *message = self.chatModel.messages[i];
        if (message.messageId == messageId) {
            // 将消息标记为发送失败，并保存到数据库 
#warning 将消息标记为发送失败，并保存到数据库
            return;
        }
    }
    /*
     (
     {
         result =     {
             clientId = 9640084527bd776bd0aa99dbdaab6c55;
             clientMsgId = "1463124718.651901";
             messageId = 230;
             msgContent = "faile test";
             receiver = "-123";
             receiverNickname = "\U94f6\U8c61";
             sendTime = "2016-05-13 15:31:57";
             sender = 1034285;
             senderNickname = "%E4%B8%9C%E5%8C%97%E7%8B%A0%E4%BA%BA1";
         };
         status = 1;
     }
     )
     */
}

/*
 result =     {
 clientId = 9640084527bd776bd0aa99dbdaab6c55;
 clientMsgId = "1463468111.058251";
 messageId = 329;
 msgContent = "\U6211\U6536\U5230";
 receiver = 201253;
 receiverNickname = "\U94f6\U8c61";
 sendTime = "2016-05-17 14:55:10";
 sender = 1034285;
 senderNickname = "%E4%B8%9C%E5%8C%97%E7%8B%A0%E4%BA%BA1";
 };
 status = 1;

 */



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
    message.receiver = self.chatModel.buddy.contactId;
    message.receiverNickname = self.chatModel.buddy.contactNickname;
    // send
    [KFZSocketTool sendMessage:message];
}
- (void)didPressAccessoryButton:(UIButton *)sender {
    NSLog(@"didPressAccessoryButton 没有实现");
}


@end





























