//
//  KFZCollMsgTableViewCell.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/25.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFZMessage.h"


@interface KFZCollMsgTableViewCell : UITableViewCell

@property (strong, nonatomic) KFZMessage *message;


+ (instancetype)msgTableViewCellWithTableView:(UITableView *)tableView ;


@end
