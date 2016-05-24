//
//  KFZBaseChatViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/16.
//  Copyright © 2016年 kongfz. All rights reserved.
//  contactId,

#import "KFZBaseChatViewController.h"

@interface KFZBaseChatViewController ()

@end

@implementation KFZBaseChatViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.senderId = [NSString stringWithFormat:@"%lu",(unsigned long)self.chatModel.sender.userId];
    self.senderDisplayName = self.chatModel.sender.nickname;
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    UIBarButtonItem *cleanContact = [[UIBarButtonItem alloc] initWithTitle:@"清除历史" style:UIBarButtonItemStylePlain target:self action:@selector(clenMessageContact)];
//    UIBarButtonItem *modifyName = [[UIBarButtonItem alloc] initWithTitle:@"修改备注" style:UIBarButtonItemStylePlain target:self action:@selector(modifyName)];
    self.navigationItem.rightBarButtonItems = @[cleanContact];
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
    [self getContactMessage];
    [KFZSocketTool socketTool].delegate = self;
}

- (void)addRefresh {
    typeof(self) ws = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getContactMessage];
    }];
    
}

- (void)clenMessageContact {
//    params:token=testToken_79453&contactId=1034285
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"contactId" : @(self.chatModel.buddy.contactId)
                             };
    [KFZNet cleanMessageContactParam:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.chatModel.messages = nil;
        [self.collectionView reloadData];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}


- (void)showTyping {
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.showTypingIndicator = !self.showTypingIndicator;
    });
}


#pragma -mark JSQMessagesCollectionViewDataSource
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if (action == @selector(copy:)) {
        [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
        return;
    }
    [self.chatModel.messages removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

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

#pragma -mark 显示时间
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    KFZMessage *message = self.chatModel.messages[indexPath.item];
    NSString *timeStr = message.sendTime ? message.sendTime : @"没有时间";
    NSDictionary *atts = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:13],
                           NSForegroundColorAttributeName : [UIColor blackColor]
                           };
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:timeStr attributes:atts];
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
    return YES;
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


#pragma -mark 子类必须实现的方法
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
- (void)socketTool:(SocketIOClient *)socket sendMessageStateNotice:(NSArray *)array {
    NSLog(@"sub class must write this method");
}


//获取历史消息
- (void)getContactMessage {
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"contactId" : @(self.chatModel.buddy.contactId),
                             @"page" : @(self.page),
                             @"pageSize" : @(MESSAGE_PAGESIZE)
                             };
    [KFZNet getContactMessageParam:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        self.page = [[responseObject[@"pager"] objectForKey:@"pageCurr"] integerValue] + 1;
        NSArray *resultArray = responseObject[@"result"];
        NSMutableArray *modelArray = [KFZMessage mj_objectArrayWithKeyValuesArray:resultArray];
        [modelArray sortUsingComparator:^NSComparisonResult(KFZMessage *msg1, KFZMessage *msg2) {
            NSComparisonResult result = [msg1.sendTime compare:msg2.sendTime];
            return result;
        }];
        [modelArray addObjectsFromArray:self.chatModel.messages];
        self.chatModel.messages = modelArray;
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        DLog(@"%@",error);
    }];
    
    /*
     {
         pager =     {
             pageCurr = 1;
             pageShow = 10;
             recordAfter = 0;
             recordBefore = 0;
             recordCount = 42;
         };
         requestInfo =     {
             contactId = 201253;
             page = 1;
             pageSize = 10;
             token = "testToken_1034285";
         };
         result =     (
             {
                 catId = 1001;
                 digest = fine;
                 isRead = 1;
                 isReplyed = 0;
                 messageId = 148;
                 msgContent = fine;
                 receiver = 1034285;
                 receiverDeleteTime = "2016-05-12 16:52:26";
                 receiverDeleted = 0;
                 receiverNickname = "\U4e1c\U5317\U72e0\U4eba1";
                 receiverPhoto = "http://user.kfz.com/data/member_pic/4285/1034285.jpg";
                 receiverSaveTime = "2016-05-12 16:52:26";
                 receiverSaved = 0;
                 richContent =             (
                 );
                 sendTime = "2016-05-12 16:52:25";
                 sender = 201253;
                 senderDeleteTime = "2016-05-12 16:52:26";
                 senderDeleted = 0;
                 senderNickname = "\U94f6\U8c61";
                 senderPhoto = "http://user.kfz.com/data/member_pic/1253/201253.jpg";
                 senderSaveTime = "2016-05-12 16:52:26";
                 senderSaved = 0;
                 urlContent = fine;
             }
         ………
         );
         status = 1;
     }

     */
}


@end




























