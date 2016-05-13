//
//  KFZMsgTableViewCell.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/13.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFZMessage.h"



@interface KFZMsgTableViewCell : UITableViewCell

@property (strong, nonatomic) KFZMessage *message;

+ (instancetype)msgTableViewCellWithTableView:(UITableView *)tableView ;

- (void)setTipState:(TipStates)state;

@end
