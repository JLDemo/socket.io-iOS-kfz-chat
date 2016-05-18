//
//  KFZNet.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
#import "KFZSocketTool.h"

typedef void(^Success_B)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^Faile_B)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@interface KFZNet : NSObject

#pragma -mark 好友相关
/// 删除好友
+ (void)deleteFriendParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;
/// 取得好友列表
+ (void)getFriendListParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;
/// 添加好友
+ (void)addFriendParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;
/// 添加好友备注
+ (void)modifyFriendNameParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;


#pragma -mark 消息相关
/// 消息联系人接口
+ (void)getContactList:(NSString *)url param:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;
/// 获取消息记录
+ (void)getContactMessageParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;

/// 清除消息记录
+ (void)cleanMessageContactParam:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile;

/// 取得消息 imServer
+ (void)getIMServerTestSuccess:(MSGBlock)sb socketTool:(KFZSocketTool *)socketTool;

///  get请求
+ (void)GET:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile;
/// post请求
+ (void)POST:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile;












@end












