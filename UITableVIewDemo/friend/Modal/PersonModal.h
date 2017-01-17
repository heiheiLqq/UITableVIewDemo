//
//  PersonModal.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModal : NSObject
//姓名
@property (nonatomic,copy)NSString * name;
//头像
@property (nonatomic,copy)NSString * icon;
//签名
@property (nonatomic,copy)NSString * circle;
+ (instancetype)personWithDic:(NSDictionary *)dic;
@end
