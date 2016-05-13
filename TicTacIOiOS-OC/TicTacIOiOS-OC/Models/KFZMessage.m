//
//  KFZMessage.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/10.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZMessage.h"

@implementation KFZMessage

+ (instancetype)messageWithTypingPhoto:(NSString *)photo receiverNickname:(NSString *)receiverNickname {
    KFZMessage *model = [[self alloc] init];
    model.receiverPhoto = photo;
    model.receiverNickname = receiverNickname;
    model.typing = YES;
    model.buddy = YES;
    return model;
}



@end



















