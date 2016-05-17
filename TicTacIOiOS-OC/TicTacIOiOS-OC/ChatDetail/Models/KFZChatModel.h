//
//  KFZChatModel.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFZMessage.h"
#import "KFZContact.h"
#import "KFZLoginInfo.h"


@interface KFZChatModel : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) JSQMessagesAvatarImage *inCommingAvatarImage;
@property (strong, nonatomic) JSQMessagesAvatarImage *outGoingAvatarImage;

@property (strong, nonatomic) JSQMessagesBubbleImage *inCommingBubbleImage;
@property (strong, nonatomic) JSQMessagesBubbleImage *outGoingBubbleImage;

@property (strong, nonatomic) KFZContact *buddy;
@property (strong, nonatomic) KFZLoginInfo *sender;

+ (instancetype)chatModelWithBuddy:(KFZContact *)buddy;


@end

























