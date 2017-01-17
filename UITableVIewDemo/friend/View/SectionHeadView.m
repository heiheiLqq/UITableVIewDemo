//
//  SectionHeadView.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "SectionHeadView.h"
#import "SectionModal.h"
@interface SectionHeadView ()
@property (weak, nonatomic) IBOutlet UIButton *sectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation SectionHeadView



-(void)setSection:(SectionModal *)section{

    _section = section;
    
    [self.sectionBtn setTitle:section.title forState:UIControlStateNormal];
    
//    self.numberLabel.text = [NSString stringWithFormat:@"%ld",section.member.count];

}

- (IBAction)btnClick:(UIButton *)btn {
    
    self.block();
}
@end
