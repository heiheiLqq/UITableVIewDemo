//
//  MessageCell.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/17.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModal.h"
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@interface MessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

@end


@implementation MessageCell



- (void)awakeFromNib {
    [super awakeFromNib];
    //设置按钮文字多行显示
    self.contentBtn.titleLabel.numberOfLines = 0;
    
}

-(void)setMessage:(MessageModal *)message{

    _message = message;
    
    
    if (message.hiddenTime) { // 隐藏时间
        self.timeLabel.hidden = YES;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    } else { // 显示时间
        self.timeLabel.text = message.time;
        self.timeLabel.hidden = NO;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21);
        }];
    }
    
    [self layoutIfNeeded];

    [self.contentBtn setTitle:message.text forState:UIControlStateNormal];
    
    UIImage * imageNormal;
    UIImage * imageHilight;
    
    if ([message.type isEqual:@(1)]) {
        
        imageNormal = [UIImage imageNamed:@"chat_send_nor"];
        
        imageHilight = [UIImage imageNamed:@"chat_send_press_pic"];
        
    }else{
        
        imageNormal = [UIImage imageNamed:@"chat_recive_nor"];
        
        imageHilight = [UIImage imageNamed:@"chat_send_recive_pic"];
        
        
    }
    //拉伸聊天内容的背景图片
    imageNormal = [imageNormal stretchableImageWithLeftCapWidth:imageNormal.size.width * 0.5 topCapHeight:imageNormal.size.height * 0.5];
    imageHilight = [imageHilight stretchableImageWithLeftCapWidth:imageHilight.size.width * 0.5 topCapHeight:imageHilight.size.height * 0.5];
    //给按钮设置内边距
    self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    
    [self.contentBtn setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:imageHilight forState:UIControlStateHighlighted];
    
    [self layoutIfNeeded];
    
    // 设置按钮的高度就是titleLabel的高度
    [self.contentBtn updateConstraints:^(MASConstraintMaker *make) {
        CGFloat buttonH = self.contentBtn.titleLabel.frame.size.height + 30;
        make.height.equalTo(buttonH);
    }];
    
    // 强制更新
    [self layoutIfNeeded];
    
    //获得头像的最大Y与文字内容的最大Y
    CGFloat timeLabelMaxY = CGRectGetMaxY(self.timeLabel.frame);
    CGFloat contentBtnMaxY = CGRectGetMaxY(self.contentBtn.frame);
    //两者较大的就是行高
    message.cellHeight = MAX(timeLabelMaxY, contentBtnMaxY)+10;

}

@end
