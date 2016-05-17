//
//  KFZSocketTool.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "KFZGetServerInfoTool.h"

@interface KFZSocketTool : NSObject<NSURLSessionDelegate>

@property (strong, nonatomic) SocketIOClient *clientSocket;
@property (strong, nonatomic) KFZLoginInfo *loginInfo;


+ (instancetype)socketTool;
+ (KFZLoginInfo *)getLoginInfo;

@end


























