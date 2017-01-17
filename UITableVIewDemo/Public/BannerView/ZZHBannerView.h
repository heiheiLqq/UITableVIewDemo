//
//  ZZHBannerView.h
//  轮播图封装练习
//
//  Created by zzh on 2017/1/12.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZHBannerViewDelegate <NSObject>

@optional
- (void)bannerViewDidClick:(NSInteger)index;

@end


@interface ZZHBannerView : UIView

@property(nonatomic,copy)NSArray * imageArr;

@property(nonatomic,strong)UIColor * normalColor;

@property (nonatomic,strong)UIColor * selectColor;

@property (nonatomic,weak) id<ZZHBannerViewDelegate>delegate;

@property (nonatomic,copy) void (^clickBlock)(NSInteger );

+(instancetype)bannerView;

@end
