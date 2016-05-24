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
    return model;
}



/**
 *  @return A string identifier that uniquely identifies the user who sent the message.
 *
 *  @discussion If you need to generate a unique identifier, consider using
 *  `[[NSProcessInfo processInfo] globallyUniqueString]`
 *
 *  @warning You must not return `nil` from this method. This value must be unique.
 */
- (NSString *)senderId {
    return [NSString stringWithFormat:@"%lu",(unsigned long)self.sender];
}
- (NSString *)senderDisplayName {
    return self.senderNickname;
}
- (NSDate *)date {
    NSDate *date = [NSDate date];
    return date;
}





//@optional

/**
 *  @return The body text of the message.
 *
 *  @warning You must not return `nil` from this method.
 */
- (NSString *)text {
    return self.msgContent;
}
- (id<JSQMessageMediaData>)media {
    return nil;
}



@end



















