//
//  IRImageCell.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "IRImageCell.h"

@interface IRImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@end

@implementation IRImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)cellHeight{
    return 250;
}

- (void)setImageUrl:(NSString *)imageUrl{
    if (imageUrl.length) {
        _picView.image = [UIImage imageWithContentsOfFile:imageUrl];
    }
}


@end
