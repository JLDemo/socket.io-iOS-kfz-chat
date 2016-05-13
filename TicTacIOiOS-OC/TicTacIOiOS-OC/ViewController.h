//
//  ViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/6.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/// 对方id
@property (assign, nonatomic) NSUInteger receiverNum;
//  对方姓名
@property (copy, nonatomic) NSString *receiverNickname;
//  对方头像
@property (copy, nonatomic) NSString *receiverPhoto;


- (void)sendMessageCallBack:(uint64_t)t array:(NSArray *)array;
@end

