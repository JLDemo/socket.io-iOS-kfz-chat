//
//  KFZChatModel.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZChatModel.h"
#import "KFZGetServerInfoTool.h"
#import "UIImage+JSQMessages.h"
#import "KFZSocketTool.h"

@implementation KFZChatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sender = [KFZGetServerInfoTool serverInfo];
//        [self fakeMessage];
    }
    return self;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (void)fakeMessage {
    KFZMessage *msg1 = [KFZMessage messageWithSenderId:@"101" displayName:@"aa" text:@"heell"];  // 1034285
    msg1.sender = 101;
    msg1.msgContent = @"hello";
    
    KFZMessage *msg2 = [KFZMessage messageWithSenderId:@"102" displayName:@"bb" text:@"hi"];
    msg2.sender = 102;
    msg2.msgContent = @"good morning";
    
    KFZMessage *msg = [KFZMessage messageWithSenderId:@"1034285" displayName:@"bb" text:@"hi"];
    msg.sender = 1034285;
    msg.msgContent = @"大家好";
    
    [self.messages addObject:msg];
    [self.messages addObject:msg1];
    [self.messages addObject:msg2];
}


+ (instancetype)chatModelWithBuddy:(KFZContact *)buddy {
    KFZChatModel *model = [[self alloc] init];
    model.buddy = buddy;
    model.sender = [KFZSocketTool getLoginInfo];
    //
    // 头像
    NSData *inAvatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:buddy.photo]];
    UIImage *inAvatarImage = [UIImage imageWithData:inAvatarData];
    inAvatarImage = inAvatarImage ? inAvatarImage : [UIImage imageNamed:@"placehodler"];
    model.inCommingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:inAvatarImage diameter:DIAMETER];
    
    NSData *outAvatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.sender.photo]];
    UIImage *outAvatarImage = [UIImage imageWithData:outAvatarData];
    outAvatarImage = outAvatarImage ? outAvatarImage : [UIImage imageNamed:@"placehodler"];
    model.outGoingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:outAvatarImage diameter:DIAMETER];
    
    // 消息背景
    JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage imageNamed:@"bubble-classic-blue"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    model.inCommingBubbleImage = [factory incomingMessagesBubbleImageWithColor:[UIColor greenColor]];
//    @property (strong, nonatomic) JSQMessagesBubbleImage *outGoingBubbleImage;
    model.outGoingBubbleImage = [factory outgoingMessagesBubbleImageWithColor:[UIColor grayColor]];
    
    return model;
}

@end



















