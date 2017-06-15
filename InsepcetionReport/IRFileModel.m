//
//  IRFileModel.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "IRFileModel.h"
#import "NSDate+Realank.h"
#import <LibXL/LibXL.h>
@implementation IRFileModel

- (instancetype)init{
    if (self = [super init]) {
        _dateString = [[NSDate date] Y_M_d_DateString];
        _supplier = @"Hetai Furnitrue";
        _checkCharger = @"DEEMO";
        
        _frontViewImageUrls = [NSMutableArray array];
        _sideViewImageUrls = [NSMutableArray array];
        _backViewImageUrls = [NSMutableArray array];
        _legViewImageUrls = [NSMutableArray array];
        
        _packageImageUrls = [NSMutableArray array];
        _sparePartsPackageImageUrls = [NSMutableArray array];
        _extraSparePartsPackageImageUrls = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString*)fileName{
    if (self = [self init]){
        _fileName = fileName;
    }
    return self;
}

- (NSString*)generateFile{
    // 创建excel文件,表格的格式是xls,如果要创建xlsx表格,需要用xlCreateXMLBook()创建
    BookHandle book = xlCreateXMLBook();
    NSInteger ret = xlBookLoad(book, [[[NSBundle mainBundle] pathForResource:@"template.xlsx" ofType:nil]  UTF8String]);
    if (ret == 0) {
        printf("%s\n",xlBookErrorMessage(book));
        return nil;
    }
    // 创建sheet表格
    SheetHandle sheet = xlBookGetSheetA(book, 0);
    //    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    /**
     *  设置表格的列宽
     *  参数1:数据要写入的表格
     *  参数2:从哪一列开始
     *  参数3:到哪一列结束
     *  参数4:具体的列宽
     *  参数5:数据要转换的格式,类型是FormatHandle,不清楚怎么定义的话可以直接写0,使用默认的
     *  参数6:隐藏属性,true
     */
    //    xlSheetSetCol(sheet, 4, 4, 15, 0, true);
    
    /**
     *  第一行的标题数据
     *  参数1:数据要写入的表格
     *  参数2:写入到哪一行
     *  参数3:写入到哪一列
     *  参数4:要写入的具体内容,注意是C字符串
     *  参数5:数据要转换的格式,类型是FormatHandle,不清楚怎么定义的话可以直接写0,使用默认的
     */
    [self fillSheet:sheet content:self.dateString inRow:5 andCol:0];
    [self fillSheet:sheet content:self.supplier inRow:5 andCol:4];
    [self fillSheet:sheet content:self.poNumber inRow:5 andCol:10];
    [self fillSheet:sheet content:self.checkCharger inRow:5 andCol:16];
    
    [self fillSheet:sheet content:self.itemNum inRow:8 andCol:0];
    [self fillSheet:sheet content:self.color inRow:8 andCol:4];
    [self fillSheet:sheet content:self.orderQuantity inRow:8 andCol:8];
    [self fillSheet:sheet content:self.finishedQuantity inRow:8 andCol:12];
    [self fillSheet:sheet content:self.inspectedQuantity inRow:8 andCol:16];
    
    [self fillSheet:sheet inBook:book image:self.frontMarkImageUrl inRow:11 andCol:0];
    [self fillSheet:sheet inBook:book image:self.sideMarkImageUrl inRow:11 andCol:5];
    [self fillSheet:sheet inBook:book image:self.assemblyInstructionImageUrl inRow:11 andCol:10];
    [self fillSheet:sheet inBook:book image:self.sparePartsImageUrl inRow:11 andCol:15];
    
    NSArray* urlArray = self.frontViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:21 andCol:0 + 5*i];
    }
    urlArray = self.sideViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:21 andCol:10 + 5*i];
    }
    urlArray = self.backViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:31 andCol:0 + 5*i];
    }
    urlArray = self.legViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:31 andCol:10 + 5*i];
    }
    
    urlArray = self.packageImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:41 andCol:0 + 5*i];
    }
    urlArray = self.sparePartsPackageImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:51 andCol:0 + 5*i];
    }
    urlArray = self.extraSparePartsPackageImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:51 andCol:10 + 5*i];
    }
    
    // 先写入沙盒
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:self.fileName];
    
    // 保存表格
    xlBookSave(book, [filePath UTF8String]);
    
    // 最后要release表格
    xlBookRelease(book);
    
    return filePath;
    
}

- (void)fillSheet:(SheetHandle)sheet content:(NSString*)content inRow:(int)row andCol:(int)col{
    if (content.length == 0 || sheet == NULL) {
        return;
    }
    xlSheetWriteStr(sheet, row, col, [content UTF8String], 0);
}

- (void)fillSheet:(SheetHandle)sheet inBook:(BookHandle)book image:(NSString*)imageUrl inRow:(int)row andCol:(int)col{
    if (imageUrl.length == 0 || sheet == NULL) {
        return;
    }
    int picId = xlBookAddPicture(book, [imageUrl UTF8String]);
    xlSheetSetPicture2A(sheet, row, col, picId, 140, 140, 60, 3, 0);
    //    xlSheetSetPictureA(sheet, row, col, picId, 1, 2, 2, 0);;
}

@end
