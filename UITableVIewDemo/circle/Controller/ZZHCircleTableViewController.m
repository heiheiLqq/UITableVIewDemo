//
//  ZZHCircleTableViewController.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHCircleTableViewController.h"
#import "CircleModal.h"
#import "CircleTableViewCell.h"
@interface ZZHCircleTableViewController ()
@property (nonatomic,copy)NSMutableArray * dataSource;

@end

@implementation ZZHCircleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CircleTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"circle"] ;

    
}
#pragma mark - 数据源初始化
-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
        
        NSMutableArray * arr = [NSMutableArray arrayWithContentsOfFile:path];
        
        for (NSDictionary * dic in arr) {
            
            CircleModal * circle = [CircleModal circleWithDic:dic];
            
            [_dataSource addObject:circle];
        }
        
    }
    
    return _dataSource;
}

#pragma mark - 代理方法
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CircleModal * circle = self.dataSource[indexPath.row];


    return circle.cellHeight;
}
//返回一个预估的高度 （配合cellHeight的使用必须实现这个代理方法）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 200;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CircleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"circle"];
    
    CircleModal * circle = self.dataSource[indexPath.row];
    
    cell.circle = circle;


    return cell;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataSource.count;


}
@end
