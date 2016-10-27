//
//  TableViewController.m
//  AwesomeIntroGuideViewDemo
//
//  Created by Senmiao on 16/7/11.
//  Copyright © 2016年 Senmiao. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0 ) {
        cell.textLabel.text = @"矩形";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"圆形";
    }
    if (indexPath.row == 2 ) {
        cell.textLabel.text = @"星形";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"其他";
    }

    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController * vc = [[ViewController alloc] init];
    if (indexPath.row == 0 ) {
        vc.type = IntroGuideType_0;
    }
    if (indexPath.row == 1) {
        vc.type = IntroGuideType_1;
    }
    if (indexPath.row == 2 ) {
        vc.type = IntroGuideType_2;
    }
    if (indexPath.row == 3) {
        vc.type = IntroGuideType_3;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
