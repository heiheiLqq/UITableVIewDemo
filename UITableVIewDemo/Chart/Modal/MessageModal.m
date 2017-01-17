//
//  MessageModal.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "MessageModal.h"

@implementation MessageModal
+ (instancetype)messageWithDic:(NSDictionary *)dic{

    MessageModal * message = [[self alloc]init];
    
    [message setValuesForKeysWithDictionary:dic];
    
    return message;

}
@end
