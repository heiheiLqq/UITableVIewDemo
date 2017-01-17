//
//  SectionModal.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModal : NSObject
//组名
@property (nonatomic,copy)NSString * title;
//组成员数组
@property (nonatomic,copy)NSArray * member;
//展开关闭状态
@property (nonatomic,assign)BOOL state;

+(instancetype)sectionWithDic:(NSDictionary *)dic;
@end
