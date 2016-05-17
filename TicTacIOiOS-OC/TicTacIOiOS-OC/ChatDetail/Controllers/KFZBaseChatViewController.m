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
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"receive" style:UIBarButtonItemStylePlain target:self action:@selector(showTyping)];
    
    
}


- (void)showTyping {
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.showTypingIndicator = !self.showTypingIndicator;
    });
}


#pragma -mark JSQMessagesCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.chatModel.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    KFZMessage *message = self.chatModel.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor blackColor];
    }else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
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

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
//    KFZMessage *message = self.chatModel.messages[indexPath.item];
    NSDictionary *atts = @{
                           NSForegroundColorAttributeName : [UIColor blackColor]
                           };
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"2016-05-10 15:50:37" attributes:atts];
    return attStr;
}
//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
// -----------
#pragma -mark JSQMessagesCollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}
//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
//                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    
}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    
}

#pragma -mark 输入框的代理方法
- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    return NO;
}

#pragma -mark socket 的代理事件
- (void)socketTool:(SocketIOClient *)socket buddyIsTyping:(NSArray *)array {
    NSLog(@"sub class must write this method");
}
- (void)socketTool:(SocketIOClient *)socket getBuddyMessage:(NSArray *)array {
    NSLog(@"sub class must write this method");
}
- (void)socketTool:(SocketIOClient *)socket sendMessageSuccess:(NSArray *)array {
    NSLog(@"sub class must write this method");
}

#pragma -mark 输入工具条点击事件
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
}
- (void)didPressAccessoryButton:(UIButton *)sender {
    NSLog(@"sub class must write this method");
}

@end




























