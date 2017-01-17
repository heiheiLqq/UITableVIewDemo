//
//  CircleModal.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleModal;


@interface CircleModal : NSObject
//文字状态
@property (nonatomic,copy)NSString * text;
//头像
@property (nonatomic,copy)NSString * icon;
//昵称
@property (nonatomic,copy)NSString * name;
//图片状态
@property (nonatomic,copy)NSString * picture;
//是否是vip
@property (nonatomic,copy , getter=isVip)NSNumber * vip;
//行高
@property (nonatomic,assign)CGFloat cellHeight;
+(instancetype)circleWithDic:(NSDictionary *)dic;
@end
