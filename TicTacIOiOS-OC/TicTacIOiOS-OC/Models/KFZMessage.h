//
//  KFZMessage.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TipStates){
    tipStatesSuccess = 0,
    tipStatesSend = 1,
    tipStatesFaile = 2
};


@interface KFZMessage : NSObject

@property (assign, nonatomic) NSUInteger catId;
//isRead = 0;
@property (copy, nonatomic) NSString *isRead;
//isReplyed = 0;
@property (assign, nonatomic) NSUInteger isReplyed;
//messageId = 2;
@property (assign, nonatomic) NSUInteger messageId;
//msgContent = off;
@property (copy, nonatomic) NSString *msgContent;
//receiver = 79453;
@property (assign, nonatomic) NSUInteger receiver;
//receiverDeleteTime = "2016-05-10 15:50:37";
@property (copy, nonatomic) NSString *receiverDeleteTime;
//receiverDeleted = 0;
//receiverNickname = "\U5408\U4f17\U4e66\U5c40";
@property (copy, nonatomic) NSString *receiverNickname;
//receiverPhoto = "http://user.kfz.com/data/member_pic/9453/79453.jpg";
@property (copy, nonatomic) NSString *receiverPhoto;
//receiverSaveTime = "2016-05-10 15:50:37";
//receiverSaved = 0;
//sendTime = "2016-05-10 15:50:36";
@property (copy, nonatomic) NSString *sendTime;
//sender = 1034285;
@property (assign, nonatomic) NSUInteger sender;
//senderDeleteTime = "2016-05-10 15:50:37";
//senderDeleted = 0;
//senderNickname = "\U4e1c\U5317\U72e0\U4eba1";
@property (copy, nonatomic) NSString *senderNickname;
//senderPhoto = "http://user.kfz.com/data/member_pic/4285/1034285.jpg";
@property (copy, nonatomic) NSString *senderPhoto;
//senderSaveTime = "2016-05-10 15:50:37";
//senderSaved = 0;
//urlContent = off;
//———————————————
//    clientId = 9640084527bd776bd0aa99dbdaab6c55;
//    clientMsgId = "1463106327.114970";
@property (copy, nonatomic) NSString *clientMsgId;

//    receiver = 201253;
//    receiverNickname = "\U94f6\U8c61";
//    sendTime = "2016-05-13 10:25:26";
@property (assign, nonatomic, getter=isTyping) BOOL typing;
@property (assign, nonatomic, getter=isBuddy) BOOL buddy;

@property (assign, nonatomic) TipStates tipState;

+ (instancetype)messageWithTypingPhoto:(NSString *)photo receiverNickname:(NSString *)receiverNickname;

@end
