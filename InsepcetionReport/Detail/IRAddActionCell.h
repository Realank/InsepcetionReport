//
//  IRAddActionCell.h
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLKBaseTableViewCell.h"

@protocol IRCellAddImageDelegate <NSObject>

- (void)cellWantToAddImageWithCamera:(BOOL)isCamera forType:(IRContentType)type;

@end

@interface IRAddActionCell : RLKBaseTableViewCell

@property (nonatomic, weak) id<IRCellAddImageDelegate> delegate;

@end
