//
//  ZZHImageView.m
//  轮播图封装练习
//
//  Created by zzh on 2017/1/13.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHImageView.h"

@interface ZZHImageView ()

@property (nonatomic,assign) SEL action;

@property (nonatomic,strong) id target;

@end

@implementation ZZHImageView
#pragma mark - g构造方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;//先让它可以接受事件
        
    }
    
    return self;
    
}
-(instancetype)init{

    self = [super init];
    
    if(self){
    
        self.userInteractionEnabled = YES;//先让它可以接受事件

    }
    return self;

}

//添加 target action 事件
-(void)addTarget:(id)target action:(SEL)selector{
    
    
    self.target = target;
    self.action = selector;
    
}

//触摸调用结束后
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //通过target 调用 action  传参 self
    
    if ([self.target respondsToSelector:self.action]) {//判断对象能否调用该方法
        
        [self.target performSelector:self.action withObject:self];
        
    }
    
}



@end
