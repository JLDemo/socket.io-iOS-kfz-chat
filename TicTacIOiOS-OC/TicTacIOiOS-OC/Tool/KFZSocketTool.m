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

typedef void(^MSGBlock)(NSString *serverAddress);

@implementation KFZSocketTool

static KFZSocketTool *socketTool;



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

@end











