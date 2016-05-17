//
//  KFZBaseChatViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZBaseChatViewController.h"

@interface KFZBaseChatViewController ()

@end

@implementation KFZBaseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.senderId = [NSString stringWithFormat:@"%d",self.chatModel.sender.userId];
    self.senderDisplayName = self.chatModel.sender.nickname;
}

#pragma -mark JSQMessagesCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chatModel.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    return cell;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.chatModel.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    KFZMessage *message = self.chatModel.messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.chatModel.outGoingBubbleImage;
    }
    return self.chatModel.inCommingBubbleImage;
}
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    KFZMessage *message = self.chatModel.messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.chatModel.outGoingAvatarImage;
    }
    return self.chatModel.inCommingAvatarImage;
}
// -----------


@end




























