//
//  SectionModal.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "SectionModal.h"
#import "PersonModal.h"
@implementation SectionModal
+(instancetype)sectionWithDic:(NSDictionary *)dic{

    SectionModal * section = [[self alloc] init];
    
    [section setValuesForKeysWithDictionary:dic];

    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * dic in section.member) {
        PersonModal * person = [PersonModal personWithDic:dic];
        [arr addObject:person];
    }
    section.member = [NSArray arrayWithArray:arr];

    
    return section;

}
@end
