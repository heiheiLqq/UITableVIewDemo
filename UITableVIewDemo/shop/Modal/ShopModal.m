//
//  ShopModal.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ShopModal.h"

@implementation ShopModal
+ (instancetype)shopModalWithDic:(NSDictionary *)dic{

    ShopModal * shop = [[self alloc]init];
    
    [shop setValuesForKeysWithDictionary:dic];

    return shop;

}
@end
