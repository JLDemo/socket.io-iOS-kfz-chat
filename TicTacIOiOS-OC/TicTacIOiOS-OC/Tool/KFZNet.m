//
//  KFZNet.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZNet.h"
#import "MJExtension.h"

@implementation KFZNet




/// 消息联系人接口
+ (void)getContactList:(NSString *)url param:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    [self POST:url params:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile(task,error);
    }];
    
}

/// 获取消息记录
+ (void)getContactMessageParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CONTACTMESSAGE];
    [self POST:urlString params:param success:success faile:faile];
}

/// 清除消息记录
+ (void)cleanMessageContactParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CLEARMESSAGE];
    [self POST:urlString params:param success:success faile:faile];
}
    
//取得消息 imServer
+ (void)getIMServerTestSuccess:(MSGBlock)sb socketTool:(KFZSocketTool *)socketTool {
    NSString *urlString = @"http://message.kfz.com/Interface/User/getImsLoginInfo";
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"device" : @"IOS",
                             @"appName" : @"IOS_KFZ_COM",
                             @"version" : @"1.4.5"
                             };
    [KFZNet POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        socketTool.loginInfo = [KFZLoginInfo mj_objectWithKeyValues:responseObject[@"result"]];
        if (socketTool.loginInfo.serverAddress.length) {
            sb(socketTool.loginInfo.serverAddress);
        }
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

+ (void)GET:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params progress:nil success:success failure:faile];
}

+ (void)POST:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:params progress:nil success:success failure:faile];
    
}



@end












