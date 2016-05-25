//
//  KFZCollMsgTableViewCell.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/25.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZCollMsgTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KFZCollMsgTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLab;

@end


@implementation KFZCollMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)msgTableViewCellWithTableView:(UITableView *)tableView  {
    static NSString *ID = @"coll_msg";
    KFZCollMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KFZCollMsgTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)setMessage:(KFZMessage *)message {
    _message = message;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:message.senderPhoto] placeholderImage:[UIImage imageNamed:@"placehodler"]];
    self.timeLab.text = message.sendTime;
    self.nameLab.text = message.senderNickname;
    self.msgContentLab.text = message.msgContent;
}



@end




















