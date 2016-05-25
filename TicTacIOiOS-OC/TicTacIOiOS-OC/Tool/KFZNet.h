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

#pragma -mark 消息设置
/// 取得消息设置
+ (void)getMessageSettingsSuccess:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile ;

#pragma -mark 好友相关
/// 删除好友
+ (void)deleteFriendParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// 取得好友列表
+ (void)getFriendListParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// 添加好友
+ (void)addFriendParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// 添加好友备注
+ (void)modifyFriendNameParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;


#pragma -mark 消息相关
/// 获取用户未读消息数量
+ (void)getUnreadMessageCountParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;

/// 删除联系人
+ (void)deleteContactParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// 消息联系人接口
+ (void)getContactListSuccess:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// 获取消息记录
+ (void)getContactMessageParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;

/**
 * 删除消息
 * param 消息id
 */
+ (void)deleteMessageIds:(NSString * _Nullable)messageIds success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile ;

/**
 * 获取分类消息
 */
+ (void)getCategoryMessagesParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;

/// 清除消息记录
+ (void)cleanMessageContactParam:(NSDictionary * _Nullable)param success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;

/// 取得消息 imServer
+ (void)getIMServerTestSuccess:(MSGBlock _Nullable)sb socketTool:(KFZSocketTool *_Nullable)socketTool;


///  get请求
+ (void)GET:(NSString * _Nullable)urlString params:(NSDictionary * _Nullable)params success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;
/// post请求
+ (void)POST:(NSString * _Nullable)urlString params:(NSDictionary * _Nullable)params success:(Success_B _Nullable)success faile:(Faile_B _Nullable)faile;












@end












