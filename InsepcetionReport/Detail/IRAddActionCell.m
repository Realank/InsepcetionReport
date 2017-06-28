//
//  IRAddActionCell.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "IRAddActionCell.h"


@implementation IRAddActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)cellHeight{
    return 44.0;
}
- (IBAction)albumAction:(id)sender {
    if (_delegate) {
        [_delegate cellWantToAddImageWithCamera:NO forType:self.contentType];
    }
}
- (IBAction)cameraAction:(id)sender {
    if (_delegate) {
        [_delegate cellWantToAddImageWithCamera:YES forType:self.contentType];
    }
}

@end
