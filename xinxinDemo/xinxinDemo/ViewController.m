//
//  ViewController.m
//  xinxinDemo
//
//  Created by 邝子涵 on 2017/10/31.
//  Copyright © 2017年 个人工作室. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// Block self 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
    
@property(nonatomic, strong)UIScrollView *baseScrollView;
    
@property(nonatomic, strong)UITableView *upTableView;
    
@property(nonatomic, strong)UIWebView *downWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.upTableView];
    [self.baseScrollView addSubview:self.downWebView];
    
    NSURL *url = [NSURL URLWithString: @"https://www.baidu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.downWebView loadRequest:request];
    
    WS(weakSelf)
    
    self.upTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.baseScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [weakSelf.upTableView.mj_footer endRefreshing];
        }];
    }];
    
    
    self.downWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.baseScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [self.downWebView.scrollView.mj_header endRefreshing];
        }];
    }];
}
    
#pragma mark -- UITableView DataSource && Delegate
    //返回表格分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
    //定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell;
}
    
    
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
        //设置分页效果
        _baseScrollView.pagingEnabled = YES;
        //禁用滚动
        _baseScrollView.scrollEnabled = NO;
    }
    return _baseScrollView;
}
    
- (UITableView *)upTableView {
    if (!_upTableView) {
        _upTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _upTableView.delegate = self;
        _upTableView.dataSource = self;
        
        
        [_upTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    }
    return _upTableView;
}
    

- (UIWebView *)downWebView {
    if (!_downWebView) {
        _downWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _downWebView.backgroundColor = [UIColor yellowColor];
        
        
        if (@available(iOS 11.0, *)){
            _downWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _downWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);//导航栏如果使用系统原生半透明的，top设置为64
            _downWebView.scrollView.scrollIndicatorInsets = _downWebView.scrollView.contentInset;
        }
    }
    return _downWebView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
