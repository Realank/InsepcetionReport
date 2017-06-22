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
    IRContentPackage2ImageUrl,
    IRContentSparePartsPackageImageUrl,
    IRContentExtraSparePartsPackageImageUrl,
    IRContentOtherImageUrl,
    IRContentMAX
} IRContentType;

@interface IRFileModel : NSObject

@property (nonatomic, copy) NSString* fileId;
@property (nonatomic, strong) NSDate* updateDate;

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

@property (nonatomic, strong) NSMutableArray* frontViewImageUrls;
@property (nonatomic, strong) NSMutableArray* sideViewImageUrls;
@property (nonatomic, strong) NSMutableArray* backViewImageUrls;
@property (nonatomic, strong) NSMutableArray* legViewImageUrls;

@property (nonatomic, strong) NSMutableArray* packageImageUrls;
@property (nonatomic, strong) NSMutableArray* package2ImageUrls;
@property (nonatomic, strong) NSMutableArray* sparePartsPackageImageUrls;
@property (nonatomic, strong) NSMutableArray* extraSparePartsPackageImageUrls;

@property (nonatomic, strong) NSMutableArray* otherImageUrls;


- (instancetype)initWithFileName:(NSString*)fileName;
- (NSString*)generateFile;

- (NSString*)draftRootDir;
- (void)saveDraft;
+ (NSArray*)loadDraftModels;
- (void)deleteDraft;
@end
