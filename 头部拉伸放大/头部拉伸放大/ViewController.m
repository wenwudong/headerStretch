/*
 本例子在tableView的tableHeaderView增加一个和imageView同样大小的空白View，
 然后根据tableView的滚动偏移量的y值，重新设定imageView的y值和高度，
 */

#import "ViewController.h"
#define imageHeight 200

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray* array;
/**
 *  容器
 */
@property (strong, nonatomic) UITableView* tableView;
/**
 *  顶部视图
 */
@property (strong, nonatomic) UIImageView* imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化容器
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    //初始化顶部视图
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, imageHeight)];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Acme_Monogram_Colour.png" ofType:nil]];
    //初始化tableHeaderView
    UIView* view = [[UIView alloc] initWithFrame:self.imageView.frame];
    [view addSubview:self.imageView];
    self.tableView.tableHeaderView = view;
}
/**
 *  隐藏状态栏
 *
 *  @return <#return value description#>
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* Cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    Cell.textLabel.text = [NSString stringWithFormat:@"%@", self.array[indexPath.row]];

    return Cell;
}

/**
 *  根据滚动距离调整图片大小
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        CGRect rect = self.imageView.frame;
        rect.origin.y = offsetY;
        rect.size.height = imageHeight - offsetY;
        self.imageView.frame = rect;
    }
}

#pragma mark 懒加载

- (NSMutableArray*)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            [_array addObject:@(i)];
        }
    }
    return _array;
}

@end
