//
//  KFZUserInfo.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/13.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZGetServerInfoTool.h"
#import "MJExtension.h"

#import "KFZSocketTool.h"

@implementation KFZGetServerInfoTool

static KFZLoginInfo *user;

+ (KFZLoginInfo *)serverInfo {
    return [KFZSocketTool getLoginInfo];
}

@end

























