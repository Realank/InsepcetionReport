//
//  IRInputCell.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "IRInputCell.h"
@interface IRInputCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@end
@implementation IRInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inputTF.delegate = self;
}

- (void)setContent:(NSString *)content{
    _inputTF.text = content;
    _inputTF.delegate = self;
}

+ (CGFloat)cellHeight{
    return 60;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString* content = textField.text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_delegate) {
        [_delegate cellContentChanged:content forType:self.contentType];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return NO;
}

@end
