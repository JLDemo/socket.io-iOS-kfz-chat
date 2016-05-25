//
//  KFZCollMsgTableViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/25.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFZMessage.h"

@interface KFZCollMsgTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<KFZMessage *> *dataSource;

@end
