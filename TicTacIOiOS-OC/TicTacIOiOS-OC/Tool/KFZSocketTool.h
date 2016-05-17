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
#import "KFZMessage.h"

@protocol KFZSocketToolDelegate <NSObject>

@optional
- (void)socketTool:(SocketIOClient *)socket buddyIsTyping:(NSArray *)array;
- (void)socketTool:(SocketIOClient *)socket getBuddyMessage:(NSArray *)array;
- (void)socketTool:(SocketIOClient *)socket sendMessageSuccess:(NSArray *)array;

@end

@interface KFZSocketTool : NSObject<NSURLSessionDelegate>

@property (weak, nonatomic) id<KFZSocketToolDelegate> delegate;

@property (strong, nonatomic) SocketIOClient *clientSocket;
@property (strong, nonatomic) KFZLoginInfo *loginInfo;


+ (instancetype)socketTool;
+ (KFZLoginInfo *)getLoginInfo;
/// 发送消息
+ (void)sendMessage:(KFZMessage *)message;

@end


























