//
//  RLKBaseTableViewCell.h
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IRCellTypeInput,
    IRCellTypeImage,
    IRCellTypeAdd,
} IRCellType;
@interface RLKBaseTableViewCell : UITableViewCell

@property (nonatomic, assign) IRContentType contentType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;



@end
