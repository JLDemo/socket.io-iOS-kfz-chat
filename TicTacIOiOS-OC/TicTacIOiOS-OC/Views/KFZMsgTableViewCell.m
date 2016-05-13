//
//  KFZMsgTableViewCell.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/13.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZMsgTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KFZMsgTableViewCell ()
@property (weak, nonatomic) UIImageView *photoView;
@property (weak, nonatomic) UILabel *contentLab;
@property (weak, nonatomic) UILabel *timeLab;
@end

@implementation KFZMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *photo = [[UIImageView alloc] init];
        [self.contentView addSubview:photo];
        self.photoView = photo;
        //
        UILabel *content = [[UILabel alloc] init];
        [self.contentView addSubview:content];
        _contentLab = content;
        content.textColor = [UIColor blackColor];
        content.font = [UIFont systemFontOfSize:11];
//        content.backgroundColor = [UIColor orangeColor];
        //
        UILabel *time = [[UILabel alloc] init];
        [self.contentView addSubview:time];
        _timeLab = time;
        _timeLab.textColor = [UIColor blackColor];
        _timeLab.font = [UIFont systemFontOfSize:10];
        _timeLab.textAlignment = NSTextAlignmentCenter;
//        content.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

+ (instancetype)msgTableViewCellWithTableView:(UITableView *)tableView {
    static NSString *cell_id = @"ims_cell";
    KFZMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    return cell;
}
- (void)setMessage:(KFZMessage *)message {
    _message = message;
    NSString *photoString = message.senderPhoto;
    NSString *placeholder = @"buddy";
    if (!message.isBuddy) {
        placeholder = @"me";
    }
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photoString] placeholderImage:[UIImage imageNamed:placeholder]];
    
    NSString *text = @"正在输入...";
    if (!message.isTyping) {
        text = message.msgContent;
    }
    self.contentLab.text = text;
    // time
    if (message.sendTime && message.sendTime.length) {
        self.timeLab.text = message.sendTime;
    }
    //
    [self setNeedsLayout];
}


- (void)setNeedsLayout {
    [super setNeedsLayout];
    CGFloat margin = 10;
    CGFloat photoWH = 30;
    if (self.message.isTyping) {
        self.photoView.frame = (CGRect){{margin, margin}, {photoWH, photoWH}};
        CGFloat contX = CGRectGetMaxX(self.photoView.frame) + margin;
        CGFloat contY = margin;
        CGFloat contW = SCREEN_Width - 3*margin - photoWH;
        CGFloat contH = self.contentView.frame.size.height - 2*margin;
        self.contentLab.frame = (CGRect){{contX, contY}, {contW, contH}};
        self.timeLab.hidden = YES;
    }else if ( self.message.isBuddy ) {
        CGFloat timeX = margin;
        CGFloat timeY = 0;
        CGFloat timeW = SCREEN_Width - 2*margin;
        CGFloat timeH = 20;
        self.timeLab.hidden = NO;
        self.timeLab.frame = (CGRect){{timeX, timeY}, {timeW, timeH}};
        //
        CGFloat photoY = CGRectGetMaxY(self.timeLab.frame);
        self.photoView.frame = (CGRect){{margin, photoY}, {photoWH, photoWH}};
        
        CGFloat contX = CGRectGetMaxX(self.photoView.frame) + margin;
        CGFloat contY = CGRectGetMaxY(self.timeLab.frame);
        CGFloat contW = SCREEN_Width - 3*margin - photoWH;
        CGFloat contH = self.contentView.frame.size.height - 2*margin;
        self.contentLab.frame = (CGRect){{contX, contY}, {contW, contH}};
    }else {
        CGFloat timeX = margin;
        CGFloat timeY = 0;
        CGFloat timeW = SCREEN_Width - 2*margin;
        CGFloat timeH = 20;
        self.timeLab.hidden = NO;
        self.timeLab.frame = (CGRect){{timeX, timeY}, {timeW, timeH}};
        //
        CGFloat photoX = SCREEN_Width - margin - photoWH;
        CGFloat photoY = CGRectGetMaxY(self.timeLab.frame);
        self.photoView.frame = (CGRect){{photoX, photoY}, {photoWH, photoWH}};
        
        CGFloat contY = CGRectGetMaxY(self.timeLab.frame);
        CGFloat contW = SCREEN_Width - 3*margin - photoWH;
        CGFloat contH = self.contentView.frame.size.height - 2*margin;
        CGFloat contX = margin;
        self.contentLab.frame = (CGRect){{contX, contY}, {contW, contH}};
    }
}



@end

















