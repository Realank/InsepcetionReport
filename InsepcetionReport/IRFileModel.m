//
//  IRFileModel.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "IRFileModel.h"
@implementation IRFileModel

- (instancetype)init{
    if (self = [super init]) {
        NSDate* date = [NSDate date];
        _fileId = [NSString stringWithFormat:@"Draft-%@-%04d",[date M_d_DateString],arc4random()%10000];
        _updateDate = date;
        _dateString = [date Y_M_d_DateString];
        _supplier = @"Hetai Furnitrue";
        _checkCharger = @"DEEMO";
        
        _frontViewImageUrls = [NSMutableArray array];
        _sideViewImageUrls = [NSMutableArray array];
        _backViewImageUrls = [NSMutableArray array];
        _legViewImageUrls = [NSMutableArray array];
        
        _packageImageUrls = [NSMutableArray array];
        _package2ImageUrls = [NSMutableArray array];
        _sparePartsPackageImageUrls = [NSMutableArray array];
        _extraSparePartsPackageImageUrls = [NSMutableArray array];
        
        _otherImageUrls = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString*)fileName{
    if (self = [self init]){
        _fileName = fileName;
    }
    return self;
}

- (NSString*)excelDir{
    NSString* excelDir = [[IRFileModel documentDir] stringByAppendingPathComponent:@"ExcelExport"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:excelDir]) {
        [fm createDirectoryAtPath:excelDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return excelDir;
}

- (NSString*)generateFile{
    //clear excel files
    NSString* excelDir = [self excelDir];
    for (NSString* fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:excelDir error:nil]) {
        NSString* filePath = [excelDir stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    // 创建excel文件,表格的格式是xls,如果要创建xlsx表格,需要用xlCreateXMLBook()创建
    BookHandle book = xlCreateXMLBook();
    NSInteger ret = 0;
    if (_package2ImageUrls.count == 0) {
        ret = xlBookLoad(book, [[[NSBundle mainBundle] pathForResource:@"template.xlsx" ofType:nil]  UTF8String]);
    }else{
        ret = xlBookLoad(book, [[[NSBundle mainBundle] pathForResource:@"template2.xlsx" ofType:nil]  UTF8String]);
    }
    
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
    int row = 5;
    [self fillSheet:sheet content:self.dateString inRow:row andCol:0];
    [self fillSheet:sheet content:self.supplier inRow:row andCol:4];
    [self fillSheet:sheet content:self.poNumber inRow:row andCol:10];
    [self fillSheet:sheet content:self.checkCharger inRow:row andCol:16];
    
    row = 8;
    [self fillSheet:sheet content:self.itemNum inRow:row andCol:0];
    [self fillSheet:sheet content:self.color inRow:row andCol:4];
    [self fillSheet:sheet content:self.orderQuantity inRow:row andCol:8];
    [self fillSheet:sheet content:self.finishedQuantity inRow:row andCol:12];
    [self fillSheet:sheet content:self.inspectedQuantity inRow:row andCol:16];
    
    row = 11;
    [self fillSheet:sheet inBook:book image:self.frontMarkImageUrl inRow:row andCol:0];
    [self fillSheet:sheet inBook:book image:self.sideMarkImageUrl inRow:row andCol:5];
    [self fillSheet:sheet inBook:book image:self.assemblyInstructionImageUrl inRow:row andCol:10];
    [self fillSheet:sheet inBook:book image:self.sparePartsImageUrl inRow:row andCol:15];
    
    row = 21;
    NSArray* urlArray = self.frontViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:0 + 5*i];
    }
    urlArray = self.sideViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:10 + 5*i];
    }
    
    row = 31;
    urlArray = self.backViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:0 + 5*i];
    }
    urlArray = self.legViewImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:10 + 5*i];
    }
    
    row = 41;
    [self fillPackageImages:self.packageImageUrls inSheet:sheet inBook:book row:row];
    
    if (_package2ImageUrls.count) {
        row = 51;
        [self fillPackageImages:self.package2ImageUrls inSheet:sheet inBook:book row:row];
    }
    
    row += 10;
    urlArray = self.sparePartsPackageImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:0 + 5*i];
    }
    urlArray = self.extraSparePartsPackageImageUrls;
    for (int i = 0; i < urlArray.count; i++) {
        NSString* imgUrl = urlArray[i];
        [self fillSheet:sheet inBook:book image:imgUrl inRow:row andCol:10 + 5*i];
    }
    
    row += 15;
    if (_otherImageUrls.count) {
        [self fillPackageImages:self.otherImageUrls inSheet:sheet inBook:book row:row];
    }
    
    // 先写入沙盒
    NSString *filePath = [excelDir stringByAppendingPathComponent:self.fileName];
    
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

- (CGSize)resize:(CGSize)originSize inSize:(CGSize)maxSize{
    CGFloat scale = MIN(maxSize.width / originSize.width , maxSize.height / originSize.height );
    CGFloat width = originSize.width * scale;
    CGFloat height = originSize.height * scale;
    return CGSizeMake(width, height);
}

- (CGRect)frameForImagePath:(NSString*)imagePath inMaxSize:(CGSize)maxSize{
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        return CGRectMake(3, 3, maxSize.width, maxSize.height);
    }
    CGSize resize = [self resize:image.size inSize:CGSizeMake(maxSize.width, maxSize.height)];
    CGRect frame = CGRectMake((maxSize.width - resize.width)/2 + 3, (maxSize.height - resize.height)/2 + 3, resize.width, resize.height);
    return frame;
}

- (void)fillPackageImages:(NSArray*)urls inSheet:(SheetHandle)sheet inBook:(BookHandle)book row:(int)row{
    if (urls.count == 0 || sheet == NULL) {
        return;
    }
    for (int i = 0; i < urls.count; i++) {
        NSString* imgUrl = urls[i];
        if (imgUrl.length == 0) {
            continue;
        }
        
        NSString* imagePath = [[self draftRootDir] stringByAppendingPathComponent:imgUrl];
        CGFloat maxWidth = 245 * 4 / urls.count;
        CGFloat maxHeight = 140;
        CGRect frame = [self frameForImagePath:imagePath inMaxSize:CGSizeMake(maxWidth - 3, maxHeight)];
        int picId = xlBookAddPicture(book, [imagePath UTF8String]);
        float cellWidth = (245 * 4 / 20.0);
        int startCol =  (maxWidth * i + frame.origin.x ) / cellWidth;
        int x =  (maxWidth * i + frame.origin.x ) - startCol * cellWidth;
        xlSheetSetPicture2A(sheet, row, startCol, picId, frame.size.width, frame.size.height, x, frame.origin.y, 0);
        
    }
    
}

- (void)fillSheet:(SheetHandle)sheet inBook:(BookHandle)book image:(NSString*)imageUrl inRow:(int)row andCol:(int)col{
    if (imageUrl.length == 0 || sheet == NULL) {
        return;
    }
    
    NSString* imagePath = [[self draftRootDir] stringByAppendingPathComponent:imageUrl];
    CGFloat maxWidth = 245;
    CGFloat maxHeight = 140;
    CGRect frame = [self frameForImagePath:imagePath inMaxSize:CGSizeMake(maxWidth, maxHeight)];
    int picId = xlBookAddPicture(book, [imagePath UTF8String]);
    //243,140
    xlSheetSetPicture2A(sheet, row, col, picId, frame.size.width, frame.size.height, frame.origin.x, frame.origin.y, 0);
    //    xlSheetSetPictureA(sheet, row, col, picId, 1, 2, 2, 0);;
}

#pragma mark - draft

+ (NSString*)documentDir{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return documentPath;
}
+ (NSString*)draftFilesRootDirectory{
    NSString* docDir = [self documentDir];
    NSString* rootDir = [docDir stringByAppendingPathComponent:@"DraftFiles"];
    return rootDir;
}
- (NSString*)draftRootDir{
    NSString* draftRootPath = [[IRFileModel draftFilesRootDirectory] stringByAppendingPathComponent:_fileId];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:draftRootPath]) {
        [fm createDirectoryAtPath:draftRootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return draftRootPath;
}

- (NSString*)formatString:(NSString*)string{
    return string.length ? string : @"";
}

- (NSDictionary*)toDict{
    return @{
             @"fileId" : [self formatString:_fileId],
             @"updateDate": _updateDate,
             @"fileName" : [self formatString:_fileName],
             
             @"dateString" : [self formatString:_dateString],
             @"supplier" : [self formatString:_supplier],
             @"poNumber" : [self formatString:_poNumber],
             @"checkCharger" : [self formatString:_checkCharger],
             
             @"itemNum" : [self formatString:_itemNum],
             @"color": [self formatString:_color],
             @"orderQuantity" : [self formatString:_orderQuantity],
             @"finishedQuantity" : [self formatString:_finishedQuantity],
             @"inspectedQuantity" : [self formatString:_inspectedQuantity],
             
             @"frontMarkImageUrl" : [self formatString:_frontMarkImageUrl],
             @"sideMarkImageUrl" : [self formatString:_sideMarkImageUrl],
             @"assemblyInstructionImageUrl" : [self formatString:_assemblyInstructionImageUrl],
             @"sparePartsImageUrl" : [self formatString:_sparePartsImageUrl],
             
             @"frontViewImageUrls" : [_frontViewImageUrls copy],
             @"sideViewImageUrls" : [_sideViewImageUrls copy],
             @"backViewImageUrls" : [_backViewImageUrls copy],
             @"legViewImageUrls" : [_legViewImageUrls copy],
                 
             @"packageImageUrls" : [_packageImageUrls copy],
             @"package2ImageUrls" : [_package2ImageUrls copy],
             @"sparePartsPackageImageUrls" : [_sparePartsPackageImageUrls copy],
             @"extraSparePartsPackageImageUrls" : [_extraSparePartsPackageImageUrls copy],
             @"otherImageUrls" : [_otherImageUrls copy],
                 };
}

- (void)saveDraft{
    _updateDate = [NSDate date];
    NSString* draftRootPath = [self draftRootDir];
    NSString* plistFilePath = [draftRootPath stringByAppendingPathComponent:@"properties.plist"];
    NSDictionary* dict = [self toDict];
    if (![dict writeToFile:plistFilePath atomically:YES]) {
        NSLog(@"保存失败");
    }
    
}

- (NSString*)filtFileUrl:(NSString*)fileUrl{
    if (fileUrl.length == 0) {
        return nil;
    }
    NSString* filePath = [[self draftRootDir] stringByAppendingPathComponent:fileUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return fileUrl;
    }
    return nil;
}

- (NSMutableArray*)filtUrlsFromArray:(NSArray*)urlArray{
    NSMutableArray* filteredUrls = [NSMutableArray array];
    for (NSString* fileUrl in urlArray) {
        if ([self filtFileUrl:fileUrl]) {
            [filteredUrls addObject:fileUrl];
        }
    }
    return filteredUrls;
}

+ (instancetype)modelFromDict:(NSDictionary*)dict{
    if (dict.allKeys.count == 0) {
        return nil;
    }
    IRFileModel* model = [[IRFileModel alloc] init];
    model.fileId = dict[@"fileId"];
    model.updateDate = dict[@"updateDate"];
    
    model.fileName = dict[@"fileName"];
    model.dateString = dict[@"dateString"];
    model.supplier = dict[@"supplier"];
    model.poNumber = dict[@"poNumber"];
    model.checkCharger = dict[@"checkCharger"];
    
    model.itemNum = dict[@"itemNum"];
    model.color = dict[@"color"];
    model.orderQuantity = dict[@"orderQuantity"];
    model.finishedQuantity = dict[@"finishedQuantity"];
    model.inspectedQuantity = dict[@"inspectedQuantity"];
    
    model.frontMarkImageUrl = [model filtFileUrl:dict[@"frontMarkImageUrl"]];
    model.sideMarkImageUrl = [model filtFileUrl:dict[@"sideMarkImageUrl"]];
    model.assemblyInstructionImageUrl = [model filtFileUrl:dict[@"assemblyInstructionImageUrl"]];
    model.sparePartsImageUrl = [model filtFileUrl:dict[@"sparePartsImageUrl"]];
    
    model.frontViewImageUrls = [model filtUrlsFromArray:dict[@"frontViewImageUrls"]];
    model.sideViewImageUrls = [model filtUrlsFromArray:dict[@"sideViewImageUrls"]];
    model.backViewImageUrls = [model filtUrlsFromArray:dict[@"backViewImageUrls"]];
    model.legViewImageUrls = [model filtUrlsFromArray:dict[@"legViewImageUrls"]];
    
    model.packageImageUrls = [model filtUrlsFromArray:dict[@"packageImageUrls"]];
    model.package2ImageUrls = [model filtUrlsFromArray:dict[@"package2ImageUrls"]];
    model.sparePartsPackageImageUrls = [model filtUrlsFromArray:dict[@"sparePartsPackageImageUrls"]];
    model.extraSparePartsPackageImageUrls = [model filtUrlsFromArray:dict[@"extraSparePartsPackageImageUrls"]];
    
    model.otherImageUrls = [model filtUrlsFromArray:dict[@"otherImageUrls"]];
    
    return model;
}

+ (NSArray*)loadDraftModels{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* draftFilesRootDir = [self draftFilesRootDirectory];
    NSArray* draftsFiles = [fm contentsOfDirectoryAtPath:draftFilesRootDir error:nil];
    NSMutableArray* draftModels = [NSMutableArray array];
    for (NSString* draftDirName in draftsFiles) {
        if ([draftDirName hasPrefix:@"Draft-"]) {
            NSString* dirPath = [draftFilesRootDir stringByAppendingPathComponent:draftDirName];
            NSString* plistFilePath = [dirPath stringByAppendingPathComponent:@"properties.plist"];
            BOOL isDir = NO;
            BOOL fileExist = [fm fileExistsAtPath:plistFilePath isDirectory:&isDir];
            if (fileExist && !isDir) {
                NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:plistFilePath];
                IRFileModel* model = [IRFileModel modelFromDict:dict];
                if (model) {
                    [draftModels addObject:model];
                }
                
            }
        }
    }
    NSArray* sortedData = [draftModels sortedArrayUsingComparator:^NSComparisonResult(IRFileModel*  _Nonnull obj1, IRFileModel*  _Nonnull obj2) {
        return [obj1.updateDate timeIntervalSinceDate:obj2.updateDate] < 0;
    }];
    return [sortedData copy];
}

- (void)deleteDraft{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* draftRootDir = [self draftRootDir];
    [fm removeItemAtPath:draftRootDir error:nil];
}

@end
