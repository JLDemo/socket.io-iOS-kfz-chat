//
//  KFZContact.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZContact.h"

@implementation KFZContact

+ (instancetype)contactWithId:(NSUInteger)contactId contactNickName:(NSString *)contactNickname {
    KFZContact *model = [[self alloc] init];
    model.contactNickname = contactNickname;
    model.contactId = contactId;
    return model;
}
@end
