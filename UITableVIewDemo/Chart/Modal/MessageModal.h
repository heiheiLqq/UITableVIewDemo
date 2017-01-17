//
//  MessageModal.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageModal : NSObject
//发送的消息
@property (nonatomic,copy)NSString * text;
//发消息时间
@property (nonatomic,copy)NSString * time;
//类型 （0是他人发给我的 1是我发给别人的）
@property (nonatomic,assign)NSNumber * type;
//判断是否需要隐藏时间
@property (nonatomic,assign)BOOL hiddenTime;
//返回行高
@property (nonatomic,assign)CGFloat cellHeight;
+ (instancetype)messageWithDic:(NSDictionary *)dic;

@end
