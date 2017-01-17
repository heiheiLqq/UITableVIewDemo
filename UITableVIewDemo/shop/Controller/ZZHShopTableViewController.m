//
//  ZZHShopTableViewController.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHShopTableViewController.h"
#import "ShopModal.h"
#import "ShopTableViewCell.h"
#import "ZZHPageView.h"
@interface ZZHShopTableViewController ()<ZZHPageViewDelegate>
@property (nonatomic, copy)NSMutableArray * dataSource;

@property (nonatomic,assign)UITableViewCellEditingStyle style;

@property (nonatomic,strong)UIBarButtonItem *add ;
@property (nonatomic,strong)UIBarButtonItem *delete ;

@property (nonatomic,strong)UIBarButtonItem *move ;

@property (nonatomic,strong)UIBarButtonItem *select ;

@end

@implementation ZZHShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpNavigation];
    
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shop"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"shop"] ;
    
    self.style = 1;
    
    ZZHPageView * pageView = [ZZHPageView pageView];
    pageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*130/300);
    
    pageView.imageArr = @[@"ad_00",@"ad_01",@"ad_02",@"ad_03",@"ad_04"];
    pageView.selectColor = [UIColor orangeColor];
    pageView.normalColor = [UIColor grayColor];
    pageView.delegate = self;
    pageView.clickBlock=^(NSInteger index){
        
        
        NSLog(@"我是block的回调点击事件，%ld",index);
    };
    
    self.tableView.tableHeaderView = pageView;
    
    
}
#pragma mark - 配置导航条
-(void)setUpNavigation{

    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    self.add = add;
    UIBarButtonItem *delete = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(remove:)];
    self.delete=delete;
    UIBarButtonItem *move = [[UIBarButtonItem alloc]initWithTitle:@"移动" style:UIBarButtonItemStylePlain target:self action:@selector(move:)];
    self.move=move;
    self.navigationItem.leftBarButtonItems = @[add,delete,move];
    
    UIBarButtonItem *select = [[UIBarButtonItem alloc]initWithTitle:@"批量删除" style:UIBarButtonItemStylePlain target:self action:@selector(select:)];
    self.select = select;
    self.navigationItem.rightBarButtonItem = select;

}
#pragma mark - 批量操作按钮点击事件
- (void)select:(UIBarButtonItem *)item{


    
    if (self.tableView.allowsMultipleSelectionDuringEditing) {
        // 获得所有被选中的行
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        
        
        // 便利所有的行号
        NSMutableArray *deletedDeals = [NSMutableArray array];
        for (NSIndexPath *path in indexPaths) {
            [deletedDeals addObject:self.dataSource[path.row]];
        }
        
        // 删除模型数据
        [self.dataSource removeObjectsInArray:deletedDeals];
        
        // 刷新表格  一定要刷新数据
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];

        
        
    }
    
    self.tableView.allowsMultipleSelectionDuringEditing = !self.tableView.allowsMultipleSelectionDuringEditing;

    item.title = self.tableView.editing?@"批量删除":@"完成";

    [self changeBarButtemItemStateWidthEditing:self.tableView.editing andClickBarButtonItem:self.select];

    
    [self.tableView setEditing:!self.tableView.editing animated:YES];





}
#pragma mark - 移动按钮点击事件
- (void)move:(UIBarButtonItem *)item{
    self.style = 0;
    
    
    item.title = self.tableView.editing?@"移动":@"完成";
    
    [self changeBarButtemItemStateWidthEditing:self.tableView.editing andClickBarButtonItem:self.move];
    
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
}
#pragma mark - 删除按钮点击事件
- (void)remove:(UIBarButtonItem *)item{
     self.style = 1;
  
    
    item.title = self.tableView.editing?@"删除":@"完成";
    
    [self changeBarButtemItemStateWidthEditing:self.tableView.editing andClickBarButtonItem:self.delete];

    
    [self.tableView setEditing:!self.tableView.editing animated:YES];


}
#pragma mark - 添加按钮点击事件
- (void)add:(UIBarButtonItem*)item{

    
    self.style = 2;

    item.title = self.tableView.editing?@"添加":@"完成";

    [self changeBarButtemItemStateWidthEditing:self.tableView.editing andClickBarButtonItem:self.add];
    
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];


}
#pragma mark -  改变导航条 四个按钮的 状态
- (void)changeBarButtemItemStateWidthEditing:(BOOL)editing andClickBarButtonItem:(UIBarButtonItem *)item{

    if (editing) {
        self.add.enabled = YES;
        self.delete.enabled = YES;
        self.move.enabled = YES;
        self.select.enabled = YES;
        self.style = 1;
        
    }else{
        self.add.enabled = [self.add isEqual: item];
        self.delete.enabled = [self.delete isEqual: item];
        self.move.enabled = [self.move isEqual: item];
        self.select.enabled = [self.select isEqual: item];
        
    }


}
#pragma mark- 数据源初始化
-(NSMutableArray *)dataSource{

    //制造假数据
    if(!_dataSource){
    
        NSString * path = [[NSBundle mainBundle] pathForResource:@"tgs.plist" ofType:nil];
     
        _dataSource = [NSMutableArray array];
        
        NSMutableArray * arr = [NSMutableArray arrayWithContentsOfFile:path];

        for (NSDictionary * dic in arr) {
            
            ShopModal * shop = [ShopModal shopModalWithDic:dic];
            [_dataSource addObject:shop];
            
        }
     
        
    }
    
    return _dataSource;

}

//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataSource.count;
}
//返回一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    ShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shop"];
    
    ShopModal * shop = self.dataSource[indexPath.row];
    
    cell.shop = shop;
    
    return cell;
    
}
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

//编辑状态的事件处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // 点击了“删除”
      
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

    }else if (editingStyle == UITableViewCellEditingStyleInsert){//点击了添加
    
        
        [self.dataSource insertObject:self.dataSource[indexPath.row] atIndex:indexPath.row];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    }
}

//返回 cell 是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //多选状态为NO 编辑状态为 0 （UITableViewCellEditingStyleNone）时才可以移动 否则其他编辑状态会干扰移动
    return !self.style && !self.tableView.allowsMultipleSelectionDuringEditing;
}
//移动操作结束的回调方法，可以获得cell初始位置和 移动后的位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //更新数据源
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

//返回当前的编辑状态 （需要同时实现编辑事件的处理方法 才会有效果）
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   self.style;
}
//自定义删除时的按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row ==0){
    
        return @"自定义";
    }
    return @"删除";

}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //设置编辑状态，默认删除状态
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}

@end
