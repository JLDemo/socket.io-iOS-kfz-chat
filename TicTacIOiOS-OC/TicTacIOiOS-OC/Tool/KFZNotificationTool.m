//
//  KFZNotificationTool.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/24.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZNotificationTool.h"

#define KEY @"key"

@implementation KFZNotificationTool

+ (void)registerLocalNotification:(KFZMessage *)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDate *fireDate = [NSDate date];
    notification.fireDate = fireDate;
    // timeZone
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSCalendarUnitEra;
    
    notification.alertBody = message.msgContent;
    notification.soundName = UILocalNotificationDefaultSoundName;
//    NSString *key = [NSString stringWithFormat:@"%@",message.senderId];
    notification.userInfo = @{
                              @"senderId" : message.senderId
                              };
    // iOS 8后注册授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithTag:(NSString *)tag {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"senderId"];
            // 如果找到需要取消的通知，则取消
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            if ([info isEqualToString:tag]) {
//                
//            }
        }
    }  
}

@end



















