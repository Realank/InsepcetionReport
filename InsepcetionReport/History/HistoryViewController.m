//
//  HistoryViewController.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/15.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "HistoryViewController.h"
#import "PreviewViewController.h"
#import "DetailTableViewController.h"
@interface HistoryViewController ()

@property (nonatomic, strong) NSArray* modelsArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    _modelsArray = [[IRFileModel loadDraftModels] copy];
    [self.tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _modelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"hisCell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"创建";
        cell.detailTextLabel.text = @"新草稿";
    }else{
        IRFileModel* model = _modelsArray[indexPath.row];
        cell.textLabel.text = model.fileName;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:model.updateDate];
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
//    cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        IRFileModel* model = _modelsArray[indexPath.row];
        __weak typeof(self) weakSelf = self;
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"删除文件？" message:model.fileName preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [model deleteDraft];
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
    
    IRFileModel* model = nil;
    if (indexPath.section == 1) {
        model = _modelsArray[indexPath.row];
    }
    DetailTableViewController *vc = [[DetailTableViewController alloc] init];
    vc.fileModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
