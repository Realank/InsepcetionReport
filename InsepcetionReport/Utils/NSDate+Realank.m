//
//  NSDate+Realank.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "NSDate+Realank.h"

@implementation NSDate (Realank)

- (NSString *)M_d_DateString{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"M-d";
//        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)Y_M_d_DateString{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/M/d";
        //        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    }
    return [dateFormatter stringFromDate:self];
}

@end
