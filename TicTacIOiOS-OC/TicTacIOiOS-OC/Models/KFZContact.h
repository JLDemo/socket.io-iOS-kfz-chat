//
//  KFZContact.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFZContact : NSObject

//contactId = 201253;
@property (assign, nonatomic) NSUInteger contactId;
//contactNickname = "\U94f6\U8c61";
@property (copy, nonatomic) NSString *contactNickname;
//lastMessageId = 148;
@property (assign, nonatomic) NSUInteger lastMessageId;
//lastMsgDate = "2016-05-12 16:52:25";
@property (copy, nonatomic) NSString *lastMsgDate;
//lastMsgDigest = fine;
@property (copy, nonatomic) NSString *lastMsgDigest;
//lastMsgcreater = oneself;
@property (copy, nonatomic) NSString *lastMsgcreater;
//onlinestate = 0;
@property (assign, nonatomic) NSUInteger onlinestate;
//photo = "http://user.kfz.com/data/member_pic/1253/201253.jpg";
@property (copy, nonatomic) NSString *photo;
//unreadNum = 0;
@property (assign, nonatomic) NSUInteger unreadNum;
//userType = "";
@property (copy, nonatomic) NSString *userType;

@end
