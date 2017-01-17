//
//  CircleTableViewCell.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CircleTableViewCell.h"

#import "Masonry.h"
@interface CircleTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation CircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCircle:(CircleModal *)circle{

    _circle = circle;
    self.headImageView.image = [UIImage imageNamed:circle.icon];
    self.nameLabel.text = circle.name;
    if([circle.isVip  isEqual: @(1)] ){
    
        self.vipImageView.hidden = NO;
        self.nameLabel.textColor = [UIColor orangeColor];

    }else{
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    
    }
    
    self.contentLabel.text = circle.text;
    
    if(circle.picture){
        self.photoImageView.image = [UIImage imageNamed:circle.picture];
        self.photoImageView.hidden = NO;
        

    }else{
    
        self.photoImageView.hidden=YES;
    }
    
    // 强制布局
    [self layoutIfNeeded];
    
    // 计算cell的高度
    if (self.photoImageView.hidden) { // 没有配图
        circle.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 10;
    } else { // 有配图
        circle.cellHeight = CGRectGetMaxY(self.photoImageView.frame) + 10;
    }
    

}
@end
