//
//  KFZSubChannels.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFZSubChannels : NSObject

/// 提出客户端 ,注意拿到这条消息时，需要判断 socketId 是否为当前 socketId ，一致不处理，不一致提出
@property (copy, nonatomic) NSString *kick;

/// 发送新消息的时使用,发送新消息反馈通知
@property (copy, nonatomic) NSString *kNewMessage;

/// 对方正在输入时
@property (copy, nonatomic) NSString *typing;

/// 接收发送给我的消息通知
@property (copy, nonatomic) NSString *privateMsg;

/// "contacts":"CONTACTS_79453",
@property (copy, nonatomic) NSString *contacts;

/// 选择对话用户时使用
@property (copy, nonatomic) NSString *clientTalkId;


@property (copy, nonatomic) NSString *notice;

/// 消息状态通知
@property (copy, nonatomic) NSString *messageStateNotice;

/// 广播消息
@property (copy, nonatomic) NSString *broadcast;

/// "unreadMessage":"UNREAD_MESSAGE_79453",
@property (copy, nonatomic) NSString *unreadMessage;

/// "instruct":"INSTRUCT_9292e9042ac8735b39953688f59d0596",
@property (copy, nonatomic) NSString *instruct;

/// 联系人变动通知
@property (copy, nonatomic) NSString *contact;

/// 发送新消息时，反馈消息接收方是否在线
@property (copy, nonatomic) NSString *onlineNotice;

@end
