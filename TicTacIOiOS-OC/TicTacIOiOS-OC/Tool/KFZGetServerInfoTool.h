//
//  KFZUserInfo.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/13.
//  Copyright © 2016年 kongfz. All rights reserved.
//  获取用户的个人信息

#import <Foundation/Foundation.h>
#import "KFZLoginInfo.h"

@interface KFZGetServerInfoTool : NSObject

+ (KFZLoginInfo *)serverInfo;

@end
