//
//  ChartViewController.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ChartViewController.h"
#import "MessageModal.h"
#import "MessageCell.h"
@interface ChartViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,copy)NSMutableArray * dataSource;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation ChartViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"消息";

    // 设置文本框左边的内容 （给光标和右侧一个间距）
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 10, 0);
    self.textFiled.leftView = leftView;
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
//页面已经加载好时默认滑到聊天页面最底部
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self scrollTableToFoot:YES];
    
    
}
#pragma mark - 数据源初始化
-(NSMutableArray *)dataSource{
    
    //制造假数据
    if(!_dataSource){
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        
        _dataSource = [NSMutableArray array];
        
        NSMutableArray * arr = [NSMutableArray arrayWithContentsOfFile:path];
        MessageModal *lastMessage = nil;
        
        for (NSDictionary * dic in arr) {
            
            MessageModal * message = [MessageModal messageWithDic:dic];
            message.hiddenTime = [message.time isEqualToString:lastMessage.time];
            
            
            [_dataSource addObject:message];
            lastMessage = message;
            
        }
        
    }
    
    return _dataSource;
    
}

#pragma mark -释放时删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘处理
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改约束
    self.bottomSpace.constant = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark scrollviewDelegate
//滑动时 回收键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    [self.view endEditing:YES];

}
#pragma mark - 聊天页面滑到底部的方法
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableview numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableview numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
#pragma mark - TableView代理
//返回行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;

}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MessageModal * message = self.dataSource[indexPath.row];

    NSString * ID = [message.type isEqual:@(1)] ? @"me":@"other";
    
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        //根据type 在我的cell和他人的cell中进行选择
        NSString * xibName = [message.type isEqual:@(1)] ? @"MeMessageCell":@"OtherMessageCell";
        
        cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
    }
    
    cell.message = message;
    
    return cell;
    
    
}
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageModal * message = self.dataSource[indexPath.row];
    

    return message.cellHeight;

}
//返回预估行高
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 10;
}


@end
