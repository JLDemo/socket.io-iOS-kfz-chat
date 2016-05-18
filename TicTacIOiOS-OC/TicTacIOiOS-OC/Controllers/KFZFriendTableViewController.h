//
//  KFZFriendTableViewController.h
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/18.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFZFriendTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) KFZSocketTool *socketTool;


@end
