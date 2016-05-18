//
//  KFZBaseChatViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "KFZChatModel.h"
#import "KFZSocketTool.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "KFZNet.h"

@interface KFZBaseChatViewController : JSQMessagesViewController<JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, JSQMessagesComposerTextViewPasteDelegate, KFZSocketToolDelegate>

@property (strong, nonatomic) KFZChatModel *chatModel;
@property (assign, nonatomic) NSUInteger page;

@property (strong, nonatomic) KFZMessage *sendMessage;
/// 收到typing消息的效果
- (void)showTyping;

- (void)addRefresh;

@end
