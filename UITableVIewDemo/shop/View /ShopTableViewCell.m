//
//  ShopTableViewCell.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "ShopModal.h"
@interface ShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;


@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setShop:(ShopModal *)shop{

    _shop = shop;
    
    self.shopImageView.image = [UIImage imageNamed:shop.icon];
    
    self.titleLabel.text = shop.title;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",shop.price];
    
    self.buyCountLabel.text = [NSString stringWithFormat:@"已有%@人购买",shop.buyCount];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
