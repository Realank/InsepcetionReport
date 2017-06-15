//
//  IRFileModel.h
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    IRContentdateString,
    IRContentsupplier,
    IRContentPONumber,
    IRContentCheckCharger,
    IRContentItemNum,
    IRContentColor,
    IRContentOrderQuantity,
    IRContentFinishedQuantity,
    IRContentInspectedQuantity,
    IRContentFrontMarkImageUrl,
    IRContentSideMarkImageUrl,
    IRContentAssemblyInstructionImageUrl,
    IRContentSparePartsImageUrl,
    IRContentFrontViewImageUrl,
    IRContentSideViewImageUrl,
    IRContentBackViewImageUrl,
    IRContentLegViewImageUrl,
    IRContentPackageImageUrl,
    IRContentSparePartsPackageImageUrl,
    IRContentExtraSparePartsPackageImageUrl,
    IRContentMAX
} IRContentType;

@interface IRFileModel : NSObject

@property (nonatomic, copy) NSString* fileName;

@property (nonatomic, copy) NSString* dateString;
@property (nonatomic, copy) NSString* supplier;
@property (nonatomic, copy) NSString* poNumber;
@property (nonatomic, copy) NSString* checkCharger;

@property (nonatomic, copy) NSString* itemNum;
@property (nonatomic, copy) NSString* color;
@property (nonatomic, copy) NSString* orderQuantity;
@property (nonatomic, copy) NSString* finishedQuantity;
@property (nonatomic, copy) NSString* inspectedQuantity;

@property (nonatomic, copy) NSString* frontMarkImageUrl;
@property (nonatomic, copy) NSString* sideMarkImageUrl;
@property (nonatomic, copy) NSString* assemblyInstructionImageUrl;
@property (nonatomic, copy) NSString* sparePartsImageUrl;

@property (nonatomic, copy) NSMutableArray* frontViewImageUrls;
@property (nonatomic, copy) NSMutableArray* sideViewImageUrls;
@property (nonatomic, copy) NSMutableArray* backViewImageUrls;
@property (nonatomic, copy) NSMutableArray* legViewImageUrls;

@property (nonatomic, copy) NSMutableArray* packageImageUrls;
@property (nonatomic, copy) NSMutableArray* sparePartsPackageImageUrls;
@property (nonatomic, copy) NSMutableArray* extraSparePartsPackageImageUrls;



- (instancetype)initWithFileName:(NSString*)fileName;
- (NSString*)generateFile;
@end
