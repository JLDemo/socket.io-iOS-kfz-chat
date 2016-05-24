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


/// 取得消息设置
+ (void)getMessageSettingsSuccess:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,GET_MSG_SETTING];
    NSDictionary *param = @{
                            @"token" : TOKEN,
                            @"device" : @"IOS",
                            @"appName" : @"IOS_KFZ_COM"
                            };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:param progress:nil success:success failure:faile];
}


/// 取得好友列表
+ (void)getFriendListParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,FRIEND_LIST];
    [self POST:urlString params:param success:success faile:faile];
}
/// 删除好友
+ (void)deleteFriendParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,DELETE_FRIEND];
    [self POST:urlString params:param success:success faile:faile];
}
/// 添加好友
+ (void)addFriendParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,ADD_FRIEND];
    [self POST:urlString params:param success:success faile:faile];
}
/// 添加好友备注
+ (void)modifyFriendNameParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,MODIFY_FRIEND_NAME];
    [self POST:urlString params:param success:success faile:faile];
}

// 删除联系人
+ (void)deleteContactParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,DELETE_CONTACT];
    [self POST:urlString params:param success:success faile:faile];
}

/// 消息联系人接口
+ (void)getContactListSuccess:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CONTACTLIST];
    NSDictionary *params = @{
                             @"token" : TOKEN
                             };
    [self POST:urlString params:params success:success faile:faile];
}

/**
 * 获取分类消息
 */
+ (void)getCategoryMessagesParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CATEGORY_MESSAGE];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:param progress:nil success:success failure:faile];
    /*
     token	签名	true	注：web用户传空值
     category	消息大类	true	[CHAT沟通类消息,CUSTOMER_SERVICE客服类消息,NOTICE通知类消息,DEAL交易类消息] ,多个分类已逗号分隔
     page	页码	true	分页页码
     pageSize	分页数	tru
     */
}

/**
 * 所有未读消息
 */
+ (void)getAllUnreadMessageCountParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,UNREAD_MESSAGE];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:param progress:nil success:success failure:faile];
}


/// 获取用户未读消息数量
+ (void)getUnreadMessageCountParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,UNREAD_MESSAGE];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:param progress:nil success:success failure:faile];
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
//        NSDictionary *result = responseObject[@"result"];
//        DLog(@"%@",result[@"nickname"]);
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












