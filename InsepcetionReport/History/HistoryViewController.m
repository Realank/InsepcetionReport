//
//  HistoryViewController.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/15.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "HistoryViewController.h"
#import "PreviewViewController.h"
@interface HistoryViewController ()

@property (nonatomic, strong) NSMutableArray* filesArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史文件";
    [self reloadData];
}

- (void)reloadData{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSArray* files = [[NSFileManager defaultManager] subpathsAtPath:documentPath];
    _filesArray = [NSMutableArray array];
    for (NSString* fileName in files) {
        if ([fileName hasSuffix:@".xlsx"]) {
            [_filesArray addObject:fileName];
        }
    }
    [self.tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hisCell"];
    
    NSString* filename = _filesArray[indexPath.row];
    cell.textLabel.text = filename;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString* fileName = _filesArray[indexPath.row];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString* filePath = [documentPath stringByAppendingPathComponent:fileName];
        __weak typeof(self) weakSelf = self;
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"删除文件？" message:fileName preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [weakSelf reloadData];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [vc addAction:confirmAction];
        [vc addAction:cancelAction];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* fileName = _filesArray[indexPath.row];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString* filePath = [documentPath stringByAppendingPathComponent:fileName];
    PreviewViewController* vc = [[PreviewViewController alloc] init];
    vc.filePath = filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
