//
//  KFZNotificationTool.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/24.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFZMessage.h"

@interface KFZNotificationTool : NSObject

+ (void)registerLocalNotification:(KFZMessage *)message ;

/**
 * 取消某个本地推送通知:发送者senderId
 */
+ (void)cancelLocalNotificationWithTag:(NSString *)key ;

@end
