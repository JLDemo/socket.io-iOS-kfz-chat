//
//  KFZFriend.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/18.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFZFriend : NSObject

// addTime = "2016-05-06 09:45:18";
@property (copy, nonatomic) NSString *addTime;
//friendId = 79453;
@property (assign, nonatomic) NSUInteger friendId;
//friendNickname = "\U5408\U4f17\U4e66\U5c40";
@property (copy, nonatomic) NSString *friendNickname;
//id = 52;主键
@property (assign, nonatomic) NSUInteger ID;
//lastTalkTime = "2016-05-18 14:31:59";
@property (copy, nonatomic) NSString *lastTalkTime;
//onlinestate = 0;
@property (assign, nonatomic) NSUInteger onlinestate;
//photo = "http://user.kfz.com/data/member_pic/9453/79453.jpg";
@property (copy, nonatomic) NSString *photo;
//remark = "";
@property (copy, nonatomic) NSString *remark;
//userId = 1034285;
@property (assign, nonatomic) NSUInteger userId;
//userType = "";
@property (copy, nonatomic) NSString *userType;

@end
