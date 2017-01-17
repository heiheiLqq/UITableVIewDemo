//
//  SectionHeadView.h
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionModal;

@interface SectionHeadView : UIView

@property (nonatomic,strong)SectionModal * section;


@property (nonatomic ,copy)void (^block)();

@end
