//
//  ShopModal.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModal : NSObject
//购买人数
@property (nonatomic, copy)NSString * buyCount;
//图片
@property (nonatomic,copy)NSString * icon;
//价格
@property (nonatomic,copy)NSString * price;
//标题
@property (nonatomic,copy)NSString * title;


+ (instancetype)shopModalWithDic:(NSDictionary *)dic;


@end
