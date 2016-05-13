//
//  KFZResult.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KFZSubChannels;

@interface KFZLoginInfo : NSObject

/// "userId":79453,
@property (assign, nonatomic) NSUInteger userId;

/// "nickname":"合众书局",
@property (copy, nonatomic) NSString *nickname;

/// "photo"
@property (copy, nonatomic) NSString *photo;

/// "serverAddress"
@property (copy, nonatomic) NSString *serverAddress;

/// "subChannels":Object{...},
@property (strong, nonatomic) KFZSubChannels *subChannels;

//"clientId":"9292e9042ac8735b39953688f59d0596",
@property (copy, nonatomic) NSString *clientId;

//"talkUserIds":false,
@property (assign, nonatomic) BOOL talkUserIds;

//"appName":"IOS_KFZ_COM",
@property (copy, nonatomic) NSString *appName;

//"version":"1.4.5",
@property (copy, nonatomic) NSString *version;

//"reqTime":1462842264,
@property (assign, nonatomic) NSUInteger reqTime;

//"permission":Object{...},
//"unreadNum":0,
@property (assign, nonatomic) NSUInteger unreadNum;
//"onlineState":Object{...},
//"settings":Object{...}
@end
















