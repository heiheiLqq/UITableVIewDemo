//
//  CircleModal.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CircleModal.h"

@implementation CircleModal
+(instancetype)circleWithDic:(NSDictionary *)dic{

    CircleModal * circle = [[self alloc]init];
    
    [circle setValuesForKeysWithDictionary:dic];
    
    return circle;

}


@end
