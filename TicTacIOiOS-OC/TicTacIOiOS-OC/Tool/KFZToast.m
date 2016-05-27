//
//  KFZToast.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/27.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZToast.h"
#import "MBProgressHUD.h"

@implementation KFZToast


+ (void)showTest:(NSString *)string {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.detailsLabelText = string;
    hud.yOffset = -60;
    hud.mode = MBProgressHUDModeCustomView;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:1.8];
        });
    });
}

@end





















