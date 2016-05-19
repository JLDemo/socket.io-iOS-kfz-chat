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

typedef void(^MSGBlock)(NSString *serverAddress);


@protocol KFZSocketToolDelegate <NSObject>

@optional
//  对话界面相关
- (void)socketTool:(SocketIOClient *)socket buddyIsTyping:(NSArray *)array;
- (void)socketTool:(SocketIOClient *)socket getBuddyMessage:(NSArray *)array;
- (void)socketTool:(SocketIOClient *)socket sendMessageSuccess:(NSArray *)array;
/* 消息状态通知 */
- (void)socketTool:(SocketIOClient *)socket sendMessageStateNotice:(NSArray *)array;

// 联系人列表相关
/* 未读消息 */
- (void)socketTool:(SocketIOClient *)socket unReadMessage:(NSArray *)array;
/* 联系人变动通知,在联系人列表中添加联系人 */
- (void)socketTool:(SocketIOClient *)socket contactChanged:(NSArray *)array;

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


























