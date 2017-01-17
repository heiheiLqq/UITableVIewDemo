//
//  ZZHPageView.h
//  轮播图封装练习
//
//  Created by zzh on 2017/1/13.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZZHPageViewDelegate <NSObject>

@optional
- (void)pageViewDidClick:(NSInteger)index;

@end
@interface ZZHPageView : UIImageView

@property (nonatomic,copy)NSArray * imageArr;
@property(nonatomic,strong)UIColor * normalColor;
@property (nonatomic,copy) void (^clickBlock)(NSInteger );
@property (nonatomic,weak) id<ZZHPageViewDelegate>delegate;

@property (nonatomic,strong)UIColor * selectColor;
+(instancetype)pageView;
@end
