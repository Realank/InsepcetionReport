//
//  IRInputCell.h
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLKBaseTableViewCell.h"

@protocol IRCellInputChanged <NSObject>

- (void)cellContentChanged:(NSString*)content forType:(IRContentType)type;

@end


@interface IRInputCell : RLKBaseTableViewCell

@property (nonatomic, copy) NSString* content;
@property (nonatomic, weak) id<IRCellInputChanged> delegate;

@end
