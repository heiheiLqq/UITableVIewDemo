//
//  ZZHFriendTableViewController.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHFriendTableViewController.h"
#import "SectionModal.h"
#import "PersonModal.h"
#import "SectionHeadView.h"
#import "ChartViewController.h"
@interface ZZHFriendTableViewController ()
@property (nonatomic,strong)NSMutableArray * dataSource;

//@property (nonatomic,strong)SectionHeadView * sectionView;


@end

@implementation ZZHFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
}


#pragma mark - 数据源
-(NSMutableArray *)dataSource{


    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc]init];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"friend.plist" ofType:nil];
        
        NSMutableArray * arr = [NSMutableArray arrayWithContentsOfFile:path];
        
        
        for (NSDictionary * dic in arr) {
            SectionModal * sec = [SectionModal sectionWithDic:dic];
            [_dataSource addObject: sec];
        }
        
    }
    return _dataSource;

}
#pragma mark - 代理方法
//返回组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSource.count;
}
//返回每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    SectionModal * sec = self.dataSource[section];
    //展开状态
    if (sec.state) {
        return sec.member.count;

    }
    //关闭状态返回0
    return 0;

}
//自定义组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

 
    SectionModal * sec = self.dataSource[section];
    
    SectionHeadView *  sectionView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SectionHeadView class]) owner:nil options:nil]lastObject];
    sectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);

    sectionView.section = sec;
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(sec) weakSec = sec;

    //组头点击的block
    sectionView.block = ^(){

        //改变每组的展开状态
        weakSec.state = ! weakSec.state;
        
        [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];

    };
    
    return sectionView;


}
//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ChartViewController * chart = [[ChartViewController alloc]initWithNibName:NSStringFromClass([ChartViewController class]) bundle:nil];
    chart.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chart animated:YES];

}
//返回组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"person"];
    }
    
    SectionModal * sec = self.dataSource[indexPath.section];
    
    PersonModal * person = sec.member[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:person.icon];
    
    cell.textLabel.text = person.name;
    
    cell.detailTextLabel.text = person.circle;
    
    
    return cell;


}
//行预估高度
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
//UITableViewRowAction。左滑  删除 置顶 等编辑选项
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //UITableViewRowActionStyleDefault = 0,
    //    UITableViewRowActionStyleDestructive = UITableViewRowActionStyleDefault,
    //    UITableViewRowActionStyleNormal
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"删除");
    }];
    action.backgroundColor = [UIColor redColor];
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标为未读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"标为未读");
    }];
    action1.backgroundColor = [UIColor orangeColor];
    UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"置顶");
    }];
    action2.backgroundColor = [UIColor grayColor];
    
    return @[action,action1,action2];
    
}
//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray * indexArr =[NSMutableArray array];
    
    for (SectionModal * modal in self.dataSource) {
        [indexArr addObject:modal.title];
    }
    
    return indexArr;
}

@end
