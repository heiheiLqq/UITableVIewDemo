## tableView性能优化 - cell的循环利用方式1

```objc
/**
 *  什么时候调用：每当有一个cell进入视野范围内就会调用
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.重用标识
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
    static NSString *ID = @"cell";

    // 1.先根据cell的标识去缓存池中查找可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    // 2.如果cell为nil（缓存池找不到对应的cell）
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    // 3.覆盖数据
    cell.textLabel.text = [NSString stringWithFormat:@"testdata - %zd", indexPath.row];

    return cell;
}
```
## tableView性能优化 - cell的循环利用方式2
- 定义一个全局变量

```objc
// 定义重用标识
NSString *ID = @"cell";
```

- 注册某个标识对应的cell类型

```objc
// 在这个方法中注册cell
- (void)viewDidLoad {
    [super viewDidLoad];

    // 注册某个标识对应的cell类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}
```

- 在数据源方法中返回cell

```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.去缓存池中查找cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    // 2.覆盖数据
    cell.textLabel.text = [NSString stringWithFormat:@"testdata - %zd", indexPath.row];

    return cell;
}
```

## tableView性能优化 - cell的循环利用方式3
- 在storyboard中设置UITableView的Dynamic Prototypes Cell

- 设置cell的重用标识

- 在代码中利用重用标识获取cell

```objc
// 0.重用标识
// 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
static NSString *ID = @"cell";

// 1.先根据cell的标识去缓存池中查找可循环利用的cell
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

// 2.覆盖数据
cell.textLabel.text = [NSString stringWithFormat:@"cell - %zd", indexPath.row];

return cell;
```


## UITableView的常见设置
```objc
// 分割线颜色
self.tableView.separatorColor = [UIColor redColor];

// 隐藏分割线
self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

// tableView有数据的时候才需要分割线
// 开发小技巧:快速取消分割线
 self.tableView.tableFooterView = [[UIView alloc] init];
//通常放广告位的轮播图
self.tableView.tableHeaderView = [[UIView alloc]init];
```

## UITableViewCell的常见设置
```objc
// 取消选中的样式(常用) 让当前 cell 按下无反应
cell.selectionStyle = UITableViewCellSelectionStyleNone;

// 设置选中的背景色
UIView *selectedBackgroundView = [[UIView alloc] init];
selectedBackgroundView.backgroundColor = [UIColor redColor];
cell.selectedBackgroundView = selectedBackgroundView;

// 设置默认的背景色
cell.backgroundColor = [UIColor blueColor];

// 设置默认的背景色
UIView *backgroundView = [[UIView alloc] init];
backgroundView.backgroundColor = [UIColor greenColor];
cell.backgroundView = backgroundView;

// backgroundView的优先级 > backgroundColor
// 设置指示器
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
cell.accessoryView = [[UISwitch alloc] init];
```

## 数据刷新方法
- 重新刷新屏幕上的所有cell<br>
```objc
[self.tableView reloadData];
```
- 刷新特定行的cell<br>
```objc
[self.tableView reloadRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0],
        [NSIndexPath indexPathForRow:1 inSection:0]
        ]
        withRowAnimation:UITableViewRowAnimationLeft];
```
- 插入特定行数的cell<br>
```objc
[self.tableView insertRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0],
        [NSIndexPath indexPathForRow:1 inSection:0]
        ]
        withRowAnimation:UITableViewRowAnimationLeft];
```
- 删除特定行数的cell<br>
```objc
[self.tableView deleteRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0],
        [NSIndexPath indexPathForRow:1 inSection:0]
        ]
        withRowAnimation:UITableViewRowAnimationLeft];
```

## 数据刷新的原则
- 通过修改模型数据，来修改tableView的展示
    - 先修改模型数据
    - 再调用数据刷新方法
- 不要直接修改cell上面子控件的属性

##tableView如何显示数据（UITableViewDataSource）
    - 设置dataSource数据源
    - 数据源要遵守UITableViewDataSource协议
    - 数据源要实现协议中的某些方法

```objc


@required
//返回tableview的组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//返回Cell 的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
//返回每组有多少行
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
// 返回每组的头部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//返回每组的尾部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
//返回是否进入编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
//返回cell是否可以进行移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//返回一个数组 右侧的索引，例如通讯录的ABCD#
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//设置索引栏标题对应的分区
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index ;
//tableView的cell编辑模式时 进行操作时触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
//tableView的cell被移动时调用的方法
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
```
##tableView的代理方法（UITableViewDelegate）
```
//cell将要显示时
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//每组的头视图将要显示时
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
//每组的尾视图将要显示时
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
//cell已经显示时
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath;
//每组的头视图已经显示时
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
//每组的尾部视图已经显示时
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//组头高度（有时候组头显示不出来可能是忘记调用该方法）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
//设置每组尾部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//设置每行的预估高度（调用此方法性能比不掉好100倍）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath;
//设置组头预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section;
//设置组尾预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section;
//自定义组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//自定义组尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
//设置cell是否可以高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
//cell高亮时调用
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
//cell取消高亮时调用
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;
//返回即将选中某行调用，返回某行位置
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//返回即将取消选中某行
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath*)indexPath;
//已经选中某行（cell  点击事件处理）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//取消选中（经常配合选中某行方法使用）
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
//设置编辑状态，默认删除状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
//自定义删除按钮的标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
//下面这个方法是IOS8中的新方法，用于自定义创建tableView被编辑时右边的按钮，按钮类型为UITableViewRowAction。
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
//设置编辑时背景是否缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//将要编辑时调用
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//取消编辑时调用
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//移动特定的某行
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;
```
##一个tableview功能介绍的小Demo
## 等高Cell

![等高CELL.jpeg ](http://upload-images.jianshu.io/upload_images/1161239-91d1390359e7ea95.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###编辑状态
```
//设置编辑属性 进入编辑状态，也可设置进入编辑状态是否需要动画
    [self.tableView setEditing:!self.tableView.editing animated:YES];
```

- 删除和添加的编辑状态

![删除.jpeg](http://upload-images.jianshu.io/upload_images/1161239-f1d8692c2f2c9907.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![添加.jpeg](http://upload-images.jianshu.io/upload_images/1161239-af3d9f0777dd4912.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```

//编辑状态的事件处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//删除状态是点击了右边的删除才会触发  并不是点击左边的减号
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // 点击了“删除”
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){//点击了添加 
        [self.dataSource insertObject:self.dataSource[indexPath.row] atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
//返回当前的编辑状态 （需要同时实现编辑事件的处理方法 才会有效果）
@property (nonatomic,assign)UITableViewCellEditingStyle style;

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//默认编辑状态是删除状态
    return   self.style;
}

```

- 自定义删除按钮的标题

![侧滑删除按钮标题的自定义.jpeg](http://upload-images.jianshu.io/upload_images/1161239-f62a7365e09c3924.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
//自定义删除时的按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//可以根据indexPath自定义任何行的删除标题
    if(indexPath.row ==0){
    
        return @"自定义";
    }
    return @"删除";

}
```

- 批量操作

![批量.jpeg](http://upload-images.jianshu.io/upload_images/1161239-65c60d716d2d9299.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
//设置这个属性为yes 可进入多选模式
self.tableView.allowsMultipleSelectionDuringEditing
//从这个方法这样返回一个进入编辑模式（个人认为这是非主流的黑魔法）
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return  UITableViewCellEditingStyleDelete |    UITableViewCellEditingStyleInsert  
}
```

```
//删除操作
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
```
- cell移动

![移动.jpeg](http://upload-images.jianshu.io/upload_images/1161239-0656bd787c1e9e97.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
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
```

##类似好友分组

- 一个可以展开和合并的非主流分组（我不是脑残！）右侧带有组标题的索引

- 两个模型

- 组模型

```
@interface SectionModal : NSObject
//组名
@property (nonatomic,copy)NSString * title;
//组成员数组
@property (nonatomic,copy)NSArray * member;
//展开关闭状态
@property (nonatomic,assign)BOOL state;

+(instancetype)sectionWithDic:(NSDictionary *)dic;
@end
```

- 人模型

```
@interface PersonModal : NSObject
//姓名
@property (nonatomic,copy)NSString * name;
//头像
@property (nonatomic,copy)NSString * icon;
//签名
@property (nonatomic,copy)NSString * circle;
+ (instancetype)personWithDic:(NSDictionary *)dic;
@end
```

```
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
//自定义组头（会复用，性能不好）
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
        //刷新tableview
        [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }；
    return sectionView;
}
```
- 展开时

![好友分组.jpeg](http://upload-images.jianshu.io/upload_images/1161239-fdfa22f28c0aef20.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 全部合并时 （传说中的非主流分组，右侧蓝色的是索引！！！！）

![一大波脑残非主流来了.jpeg](http://upload-images.jianshu.io/upload_images/1161239-a2c7b8ba97ddc93c.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * indexArr =[NSMutableArray array];
    for (SectionModal * modal in self.dataSource) {
        [indexArr addObject:modal.title];
    }
    return indexArr;
}
```

- 自定义多个编辑按钮

![侧滑编辑按钮自定义.jpeg](http://upload-images.jianshu.io/upload_images/1161239-ca1e39e823bb5ac3.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```

//UITableViewRowAction。左滑  删除 置顶 等编辑选项 （iOS8以后）
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

```

## 非等高Cell

##一个简单仿照朋友圈的列表

![简单的非等高cell.jpeg](http://upload-images.jianshu.io/upload_images/1161239-d818ecf725dd9f01.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

关键在于cell高度的处理，数据模型中加入一个cellHeight属性

```
@interface CircleModal : NSObject
//文字状态
@property (nonatomic,copy)NSString * text;
//头像
@property (nonatomic,copy)NSString * icon;
//昵称
@property (nonatomic,copy)NSString * name;
//图片状态
@property (nonatomic,copy)NSString * picture;
//是否是vip
@property (nonatomic,copy , getter=isVip)NSNumber * vip;
//行高
@property (nonatomic,assign)CGFloat cellHeight;
+(instancetype)circleWithDic:(NSDictionary *)dic;
@end
```

在cell的Set方法中布局完成后获得高度 赋给模型

```
-(void)setCircle:(CircleModal *)circle{

    _circle = circle;
    self.headImageView.image = [UIImage imageNamed:circle.icon];
    self.nameLabel.text = circle.name;
    if([circle.isVip  isEqual: @(1)] ){
        self.vipImageView.hidden = NO;
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    self.contentLabel.text = circle.text;
    if(circle.picture){
        self.photoImageView.image = [UIImage imageNamed:circle.picture];
        self.photoImageView.hidden = NO;
    }else{
        self.photoImageView.hidden=YES;
    }
    // 强制布局
    [self layoutIfNeeded];  
    // 计算cell的高度
    if (self.photoImageView.hidden) { // 没有配图
        circle.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + 10;
    } else { // 有配图
        circle.cellHeight = CGRectGetMaxY(self.photoImageView.frame) + 10;
    }
}
```
如此在控制器中就可以拿到cell的高度

```
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleModal * circle = self.dataSource[indexPath.row];
    return circle.cellHeight;
}
```

但是！！！ 一定要注意,一定要实现下面这个方法，以前只知道这个方法可以优化性能，如果这个方法不实现，tableview 会在 (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 这个cell创建方法调用之前 多次调用上面返回行高的方法，此时cell还是nil会导致程序崩溃，实现了下面 预估行高的方法，tableview创建cell前就不会调用上面的方法！

通过打印日志可以看出  如果不实现下面方法 创建cell前 每个row创建之前都要调用三遍heightForRowAtIndexPath，这样一次性调用了几十遍，实现了estimatedHeightForRowAtIndexPath，后tableview 每次先创建cell然后返回一次rowHeight，这就是下面这个方法解决性能的由来！

```
//返回一个预估的高度 （配合cellHeight的使用必须实现这个代理方法）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
```

##仿照聊天消息界面

![仿聊天.jpeg](http://upload-images.jianshu.io/upload_images/1161239-f1f9e8f70039825b.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

左右两种cell，每个消息是一个模型，通过MessageModal中的type参数来区分是我发给别人的消息还是别人发给我的消息
```
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

```

看似简单，还是遇到了许多问题，尤其是在计算高度的时候，聊天内容选择的是btn 因为有个背景图，然后发现用button处理一些文字计算高度，远远不如label简单

```
-(void)setMessage:(MessageModal *)message{
    _message = message;
    if (message.hiddenTime) { // 隐藏时间
        self.timeLabel.hidden = YES;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    } else { // 显示时间
        self.timeLabel.text = message.time;
        self.timeLabel.hidden = NO;
        [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21);
        }];
    }  
//约束设置完后必须强制更新下，才会拿到真正的frame等尺寸  
    [self layoutIfNeeded];
    [self.contentBtn setTitle:message.text forState:UIControlStateNormal];   
    UIImage * imageNormal;
    UIImage * imageHilight; 
//判断是我发的消息，还是收的消息
    if ([message.type isEqual:@(1)]) {
        imageNormal = [UIImage imageNamed:@"chat_send_nor"];   
        imageHilight = [UIImage imageNamed:@"chat_send_press_pic"];  
    }else{    
        imageNormal = [UIImage imageNamed:@"chat_recive_nor"];      
        imageHilight = [UIImage imageNamed:@"chat_send_recive_pic"];       
   }
    //拉伸聊天内容的背景图片
    imageNormal = [imageNormal stretchableImageWithLeftCapWidth:imageNormal.size.width * 0.5 topCapHeight:imageNormal.size.height * 0.5];
    imageHilight = [imageHilight stretchableImageWithLeftCapWidth:imageHilight.size.width * 0.5 topCapHeight:imageHilight.size.height * 0.5];
    //给按钮设置内边距（不然文字显示会有问题）
    self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    [self.contentBtn setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:imageHilight forState:UIControlStateHighlighted];  
    [self layoutIfNeeded];  
    // 设置按钮的高度就是titleLabel的高度
    [self.contentBtn updateConstraints:^(MASConstraintMaker *make) {
        CGFloat buttonH = self.contentBtn.titleLabel.frame.size.height + 30;
        make.height.equalTo(buttonH);
    }]; 
    // 强制更新
    [self layoutIfNeeded];
    //获得头像的最大Y与文字内容的最大Y
    CGFloat timeLabelMaxY = CGRectGetMaxY(self.timeLabel.frame);
    CGFloat contentBtnMaxY = CGRectGetMaxY(self.contentBtn.frame);
    //两者较大的就是行高
    message.cellHeight = MAX(timeLabelMaxY, contentBtnMaxY)+10;
}

```

Demo地址（https://github.com/heiheiLqq/UITableVIewDemo）
