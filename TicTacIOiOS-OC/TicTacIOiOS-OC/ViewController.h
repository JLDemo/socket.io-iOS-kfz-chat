//
//  ViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/6.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/// 接收方id
@property (assign, nonatomic) NSUInteger receiverNum;
//  接收方姓名
@property (copy, nonatomic) NSString *receiverNickname;


- (void)sendMessageCallBack:(uint64_t)t array:(NSArray *)array;
@end

