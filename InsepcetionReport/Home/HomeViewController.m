//
//  HomeViewController.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/15.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailTableViewController.h"
#import "HistoryViewController.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *hisBtn;
@property (weak, nonatomic) IBOutlet UIButton *genBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Deemo报告";
    [self configCorner:_hisBtn];
    [self configCorner:_genBtn];
}

- (void)configCorner:(UIView*)view{
    view.layer.cornerRadius = 15;
}

- (IBAction)showHistoryPage:(id)sender {
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)generateNewFile:(id)sender {
    DetailTableViewController *vc = [[DetailTableViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

@end
