//
//  KFZSocketTool.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZSocketTool.h"

#import "KFZNet.h"
#import "KFZSubChannels.h"


@implementation KFZSocketTool

static KFZSocketTool *socketTool = nil;



+ (instancetype)socketTool {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        socketTool = [[self alloc] init];
//    });
    return socketTool;
}

+ (void)initialize {
    [super initialize];
    socketTool = [[self alloc] init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSGBlock b = ^(NSString *serverAddress){
            [self getConnection:serverAddress];
        };
//        [self getIMServerTestSuccess:b];
        [KFZNet getIMServerTestSuccess:b socketTool:socketTool];
    });
}

+ (KFZLoginInfo *)getLoginInfo {
    if (socketTool == nil) {
        [NSThread sleepForTimeInterval:1];
    }
    return socketTool.loginInfo;
}





////  参数转字典
+ (NSDictionary *)paramsConvertIntoDictonary:(NSString *)paramString {
    NSArray *kvArray = [paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (int i=0; i<kvArray.count; i++) {
        NSString *str = kvArray[i];
        NSArray *paramArray = [str componentsSeparatedByString:@"="];
        [params setValue:[paramArray lastObject] forKey:[paramArray firstObject]];
    }
    return params;
}

+ (void)getConnection:(NSString *)address {
    NSArray *urlArray = [address componentsSeparatedByString:@"?"];
    NSString *urlString = [urlArray firstObject];
    NSString *paramStr = [urlArray lastObject];
    NSDictionary *params = [self paramsConvertIntoDictonary:paramStr];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];  //
    NSDictionary *options =
    @{@"log": @YES,
      @"forcePolling": @YES,
      @"forceWebsockets": @YES,
      @"VoipEnabled" : @YES,
      @"connectParams" : params
      };
    socketTool.clientSocket = [[SocketIOClient alloc] initWithSocketURL:url options:options];
    //
    [socketTool.clientSocket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket connected");
        [self listeningSubChannals];
    }];
    
    [socketTool.clientSocket on:@"reconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket reconnect");
    }];
    [socketTool.clientSocket on:@"error" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket error");
    }];
    [socketTool.clientSocket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================disconnect");
    }];
    [socketTool.clientSocket connect];
}


+ (void)listeningSubChannals {
    KFZSubChannels *subChannels = socketTool.loginInfo.subChannels;
    
    
    /// 提出客户端 ,注意拿到这条消息时，需要判断 socketId 是否为当前 socketId ，一致不处理，不一致提出
//    @property (copy, nonatomic) NSString *kick;
    [socketTool.clientSocket on:subChannels.kick callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"========================kick\n\n");
    }];
    /// 发送新消息的时使用,发送新消息反馈通知
    [socketTool.clientSocket on:subChannels.kNewMessage callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:sendMessageSuccess:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket sendMessageSuccess:array];
        }
    }];
//    /// 对方正在输入时
    [socketTool.clientSocket on:subChannels.typing callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:buddyIsTyping:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket buddyIsTyping:array];
        }
    }];
//    /// 接收发送给我的消息通知
//    @property (copy, nonatomic) NSString *privateMsg;
    [socketTool.clientSocket on:subChannels.privateMsg callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:getBuddyMessage:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket getBuddyMessage:array];
        }
    }];
//    /// "contacts":"CONTACTS_79453",
//    @property (copy, nonatomic) NSString *contacts;
    [socketTool.clientSocket on:subChannels.contacts callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// 选择对话用户时使用
//    @property (copy, nonatomic) NSString *clientTalkId;
    [socketTool.clientSocket on:subChannels.clientTalkId callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];

//    @property (copy, nonatomic) NSString *notice;
//    
//    /// 消息状态通知
//    @property (copy, nonatomic) NSString *messageStateNotice;
    [socketTool.clientSocket on:subChannels.messageStateNotice callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:sendMessageStateNotice:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket sendMessageStateNotice:array];
        }
    }];
    
//    /// 广播消息
//    @property (copy, nonatomic) NSString *broadcast;
    [socketTool.clientSocket on:subChannels.broadcast callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// "unreadMessage":"UNREAD_MESSAGE_79453",
//    @property (copy, nonatomic) NSString *unreadMessage;
    [socketTool.clientSocket on:subChannels.unreadMessage callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:unReadMessage:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket unReadMessage:array];
        }
    }];
//    /// "instruct":"INSTRUCT_9292e9042ac8735b39953688f59d0596",
//    @property (copy, nonatomic) NSString *instruct;
    [socketTool.clientSocket on:subChannels.instruct callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// 联系人变动通知,在联系人列表中添加联系人
//    @property (copy, nonatomic) NSString *contact;
    [socketTool.clientSocket on:subChannels.contact callback:^(NSArray *array, SocketAckEmitter *ack) {
        if ([socketTool.delegate respondsToSelector:@selector(socketTool:contactChanged:)]) {
            [socketTool.delegate socketTool:socketTool.clientSocket contactChanged:array];
        }
    }];
//    /// 发送新消息时，反馈消息接收方是否在线
//    @property (copy, nonatomic) NSString *onlineNotice;
    [socketTool.clientSocket on:subChannels.onlineNotice callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
}






+ (void)sendMessage:(KFZMessage *)message {
    //    sender	发送者编号	true
    NSUInteger senderNum = message.sender;
    //    senderNickname
    NSString *senderNickname = message.senderNickname;
    //    receiver	接收者编号	true
    //    receiverNickname	接受者昵称	true
    //    msgContent	消息内容
    //    clientMsgId	客户端消息Id
    NSDate *date = [NSDate date];
    NSString *clientMsgId = [NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]];
    
    NSDictionary *params = @{
                             @"sender" : @(senderNum),
                             @"senderNickname" : senderNickname,
                             @"receiver" : @(message.receiver),  //  @(message.receiver)
                             @"receiverNickname" : message.receiverNickname,
                             @"msgContent" : message.msgContent, //
                             @"clientMsgId" : clientMsgId  // clientMsgId
                             };
    NSArray *array = @[params];
    
    [socketTool.clientSocket emitWithAck:@"NEW_MESSAGE" withItems:array](0, ^(NSArray* data) {
        [socketTool.clientSocket emit:@"NEW_MESSAGE" withItems:array];
    });
}









@end




















