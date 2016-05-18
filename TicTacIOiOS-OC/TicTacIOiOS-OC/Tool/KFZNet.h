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












