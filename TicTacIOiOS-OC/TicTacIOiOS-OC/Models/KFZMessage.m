//
//  KFZMessage.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZMessage.h"

@implementation KFZMessage
+ (instancetype)messageWithUserId:(NSUInteger)userId msg:(NSString *)msg {
    KFZMessage *obj = [[self alloc] init];
    obj.typingUserId = userId;
    obj.msg = msg;
    return obj;
}
@end



















