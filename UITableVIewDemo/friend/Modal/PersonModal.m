//
//  PersonModal.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "PersonModal.h"

@implementation PersonModal
+ (instancetype)personWithDic:(NSDictionary *)dic{

    PersonModal * person = [[self alloc]init];
    
    [person setValuesForKeysWithDictionary:dic];

    return person;
}
@end
