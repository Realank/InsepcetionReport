//
//  DetailTableViewController.h
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRFileModel.h"
@interface DetailTableViewController : UITableViewController

@property (nonatomic, strong) IRFileModel* fileModel;

@end
