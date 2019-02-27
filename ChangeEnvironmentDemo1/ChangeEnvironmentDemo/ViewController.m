//
//  ViewController.m
//  ChangeEnvironmentDemo
//
//  Created by YangYongJie on 2019/2/27.
//  Copyright © 2019年 yyj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *switchEvironmentButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
#if DEBUG
    [self.view addSubview:self.switchEvironmentButton];
#else
#endif
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", self.switchEvironmentButton.titleLabel.text, BASEURL];
    return cell;
}

#pragma mark - event response
- (void)changeEnviorment:(UIButton *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"切换环境" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"debug enviroment" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 1、改变按钮title
        [self.switchEvironmentButton setTitle:action.title forState:UIControlStateNormal];
        // 2、切换到debug环境
        [[NSUserDefaults standardUserDefaults] setValue:DEBUG_BASEURL forKey:kBaseUrl];
        // 3、退出登录，清除当前用户信息，重新登录，刷新数据
        [self.tableView reloadData];
    }]];
    
    [actionSheet addAction:[UIAlertAction  actionWithTitle:@"release enviroment" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        // 1、改变按钮title
        [self.switchEvironmentButton setTitle:action.title forState:UIControlStateNormal];
        // 2、切换到release环境
        [[NSUserDefaults standardUserDefaults] setValue:RELEASE_BASEURL forKey:kBaseUrl];
        // 3、退出登录，清除当前用户信息，重新登录，刷新数据
        [self.tableView reloadData];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - getters
- (UIButton *)switchEvironmentButton
{
    if (_switchEvironmentButton == nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 220, 200, 50)];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"debug environment" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeEnviorment:) forControlEvents:UIControlEventTouchUpInside];
        _switchEvironmentButton = button;
    }
    return _switchEvironmentButton;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
