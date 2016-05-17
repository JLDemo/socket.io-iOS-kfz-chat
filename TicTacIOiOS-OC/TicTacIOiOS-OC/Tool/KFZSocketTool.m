//
//  KFZSocketTool.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZSocketTool.h"
#import "MJExtension.h"
#import "KFZNet.h"
#import "KFZSubChannels.h"

typedef void(^MSGBlock)(NSString *serverAddress);

@implementation KFZSocketTool

static KFZSocketTool *socketTool = nil;



+ (instancetype)socketTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketTool = [[self alloc] init];
    });
    return socketTool;
}

+ (void)initialize {
    [super initialize];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MSGBlock b = ^(NSString *serverAddress){
            [self getConnection:serverAddress];
        };
        [self getIMServerTestSuccess:b];
    });
}

+ (KFZLoginInfo *)getLoginInfo {
    if (socketTool == nil) {
        [NSThread sleepForTimeInterval:1];
    }
    return socketTool.loginInfo;
}


//取得消息 imServer
+ (void)getIMServerTestSuccess:(MSGBlock)sb {
    NSString *urlString = @"http://message.kfz.com/Interface/User/getImsLoginInfo";
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"device" : @"IOS",
                             @"appName" : @"IOS_KFZ_COM",
                             @"version" : @"1.4.5"
                             };
    [KFZNet POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        socketTool.loginInfo = [KFZLoginInfo mj_objectWithKeyValues:responseObject[@"result"]];
        sb(socketTool.loginInfo.serverAddress);
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
        ;
    }];
    
//    /// 广播消息
//    @property (copy, nonatomic) NSString *broadcast;
    [socketTool.clientSocket on:subChannels.broadcast callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// "unreadMessage":"UNREAD_MESSAGE_79453",
//    @property (copy, nonatomic) NSString *unreadMessage;
    [socketTool.clientSocket on:subChannels.unreadMessage callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// "instruct":"INSTRUCT_9292e9042ac8735b39953688f59d0596",
//    @property (copy, nonatomic) NSString *instruct;
    [socketTool.clientSocket on:subChannels.instruct callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// 联系人变动通知
//    @property (copy, nonatomic) NSString *contact;
    [socketTool.clientSocket on:subChannels.contact callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
//    /// 发送新消息时，反馈消息接收方是否在线
//    @property (copy, nonatomic) NSString *onlineNotice;
    [socketTool.clientSocket on:subChannels.onlineNotice callback:^(NSArray *array, SocketAckEmitter *ack) {
        ;
    }];
}






+ (void)sendMessage:(KFZMessage *)message {
    SocketIOClient *clientSocket = socketTool.clientSocket;
//    clientSocket emitWithAck:<#(NSString * _Nonnull)#> withItems:<#(NSArray * _Nonnull)#>
}








@end




















