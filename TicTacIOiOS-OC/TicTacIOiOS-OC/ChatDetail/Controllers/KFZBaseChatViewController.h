//
//  KFZBaseChatViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "KFZChatModel.h"

@interface KFZBaseChatViewController : JSQMessagesViewController<JSQMessagesCollectionViewDataSource>

@property (strong, nonatomic) KFZChatModel *chatModel;



@end
