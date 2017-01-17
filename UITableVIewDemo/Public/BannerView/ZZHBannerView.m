//
//  ZZHBannerView.m
//  轮播图封装练习
//
//  Created by zzh on 2017/1/12.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHBannerView.h"
#import "ZZHImageView.h"
@interface ZZHBannerView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong ,nonatomic)NSTimer * timer;
@end

@implementation ZZHBannerView

+(instancetype)bannerView{

    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];

}
#pragma mark - xib初始化
-(void)awakeFromNib{

    [super awakeFromNib];
    //初始化一些参数
    [self setUp];
    
}
-(void)layoutSubviews{
    
    
    
    //imageView 的宽高
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    //imageView 的个数
    NSInteger count = self.scrollView.subviews.count;
    //pageControl的坐标
    CGFloat pageW = 100;
    CGFloat pageH = 50;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    
    self.scrollView.frame=self.bounds;
    
    for (int i = 0 ; i< count;i++){
        
        ZZHImageView * imageView = self.scrollView.subviews[i];
        
        imageView.frame = CGRectMake(i*scrollW, 0, scrollW, scrollH);
        
    }
    self.scrollView.contentSize = CGSizeMake(scrollW*count, 0);
    
    //默认从第二张开始
    [self.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];

    
}
-(void)setUp{
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.hidesForSinglePage = YES;
    [self startTimer];
}
#pragma mark - NSTimer
-(void)startTimer{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
-(void)stopTimers{

    [self.timer invalidate];
    self.timer = nil;
}
-(void)nextPage{

    CGPoint point;
    //判断滑到的位置
    int index = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width + 0.5);

    if(index == self.imageArr.count-1){
        //如果最后一张跳第二张 没有动画 制造假象
        point = CGPointMake(self.scrollView.frame.size.width, 0);
         [self.scrollView setContentOffset:point animated:NO];

    }else{
        //跳下一张
        point = CGPointMake((index+1)*self.scrollView.frame.size.width, 0);
        [self.scrollView setContentOffset:point animated:YES];

    }
    
}
#pragma mark 图片点击事件
-(void)imageClick:(ZZHImageView *)imageView{

    NSInteger index;
    
    switch (imageView.tag) {
        case 0:
            index = self.imageArr.count-2;
            break;
        case 6:
            index = 0;
            break;
            
        default:
            index = imageView.tag-1;
            break;
    }
    
    [self.delegate bannerViewDidClick:index];
    
    self.clickBlock(index);
    
}
#pragma mark - set方法
-(void)setImageArr:(NSArray *)imageArr{

    NSMutableArray * arr = [NSMutableArray arrayWithArray:imageArr];

    //数组首位插入最后一张图
    [arr insertObject:[imageArr lastObject] atIndex:0];
    //数组末尾插入第一张图
    [arr insertObject:[imageArr firstObject] atIndex:arr.count];

    _imageArr = [NSArray arrayWithArray:arr];
    
    
    // 移除之前的所有imageView
    // 让subviews数组中的所有对象都执行removeFromSuperview方法
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (int i = 0 ; i< _imageArr.count;i++){
    
        ZZHImageView * imageView = [[ZZHImageView alloc]init];
        imageView.image = [UIImage imageNamed:_imageArr[i]];
        imageView.tag = i;
        [imageView addTarget:self action:@selector(imageClick:)];
        [self.scrollView addSubview:imageView];
    
    }
    self.pageControl.numberOfPages = _imageArr.count-2;
    
}
-(void)setNormalColor:(UIColor *)normalColor{

    _normalColor = normalColor;
    self.pageControl.pageIndicatorTintColor = normalColor;

}
-(void)setSelectColor:(UIColor *)selectColor{

    _selectColor = selectColor;
    self.pageControl.currentPageIndicatorTintColor = selectColor;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //判断滑到的位置
    int index = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    
    if(index == 0){
    
        //索引0显示的是最后一张图
        self.pageControl.currentPage = self.imageArr.count-2;

    }else if(index == self.imageArr.count -1){
        //索引末尾显示第一张图
        self.pageControl.currentPage = 0;
    }else{
    
        self.pageControl.currentPage = index-1;
    }
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self stopTimers];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self startTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point;
    //拖动惯性取消时 判断滑到的位置
    int index = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    
    if(index == scrollView.subviews.count-1){
        //滑到最后位置显示的是第一张图  没有动画跳（制造假象）到 索引1的位置 （索引1也是第一张图  ）
        point = CGPointMake(scrollView.frame.size.width, 0);
        [scrollView setContentOffset:point animated:NO];
        
    }else if (index == 0){
    
        //滑到索引喂0的位置显示的是最后一张图 没有动画（制造假象） 跳到 索引倒数第二个位置  （显示的也是最后一张图）（反向滑动）
        point = CGPointMake(scrollView.frame.size.width*(self.imageArr.count-2), 0);
        [scrollView setContentOffset:point animated:NO];
    }

}
@end
