//
//  KFZMessage.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFZMessage : NSObject
@property (assign, nonatomic) NSUInteger typingUserId;

@property (copy, nonatomic) NSString *msg;

+ (instancetype)messageWithUserId:(NSUInteger)userId msg:(NSString *)msg;
@end
