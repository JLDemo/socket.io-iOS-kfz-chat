//
//  KFZMessage.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZMessage.h"

@implementation KFZMessage
+ (instancetype)messageWithUserId:(NSUInteger)userId userName:(NSString *)userName msg:(NSString *)msg {
    KFZMessage *obj = [[self alloc] init];
    obj.typingUserId = userId;
    obj.userName = userName;
    obj.msg = msg;
    return obj;
}
@end



















