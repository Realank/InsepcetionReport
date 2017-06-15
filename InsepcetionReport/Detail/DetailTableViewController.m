//
//  DetailTableViewController.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/14.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "DetailTableViewController.h"
#import "IRInputCell.h"
#import "IRImageCell.h"
#import "IRAddActionCell.h"
#import "NSDate+Realank.h"
#import <AVFoundation/AVFoundation.h>
#import "PreviewViewController.h"
@interface DetailTableViewController ()<IRCellInputChanged, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) IRContentType selectImageType;
@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateTableViewHeaderText];
    self.tableView.sectionHeaderHeight = 25;
    self.title = @"生成文件";
    
    UIBarButtonItem* resetItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:resetItem];
    
    UIBarButtonItem* genItem = [[UIBarButtonItem alloc] initWithTitle:@"生成" style:UIBarButtonItemStylePlain target:self action:@selector(generateFile)];
    [self.navigationItem setRightBarButtonItem:genItem];
}

- (void)back{
    
    __weak typeof(self) weakSelf = self;
    UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"返回将丢失数据" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.fileModel = nil;
        //    [self updateTableViewHeaderText];
        //    [self.tableView reloadData];
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:confirmAction];
    [vc addAction:cancelAction];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    

}

- (void)updateTableViewHeaderText{
    NSString* itemNum = _fileModel.itemNum.length > 0 ? _fileModel.itemNum : @"itemNum";
    NSString* color = _fileModel.color.length > 0 ? _fileModel.color : @"colour";
    NSString* fileName = [NSString stringWithFormat:@"%@-Inspection Report-%@-%@.xlsx",[[NSDate date] M_d_DateString],itemNum,color];
    if (!_fileModel) {
        _fileModel = [[IRFileModel alloc] initWithFileName:fileName];
    }else{
        _fileModel.fileName = fileName;
    }
    if (![self.tableView.tableHeaderView isKindOfClass:[UILabel class]]) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        label.text = _fileModel.fileName;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        self.tableView.tableHeaderView = label;
    }else{
        UILabel* label = (UILabel*)self.tableView.tableHeaderView;
        label.text = _fileModel.fileName;
    }
    
}

- (void)generateFile{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"请确认文件名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = [weakSelf.fileModel.fileName stringByDeletingPathExtension];
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* tf = [vc.textFields firstObject];
        if (tf.text.length == 0) {
            return;
        }
        NSString* fileName = [tf.text stringByAppendingPathExtension:@"xlsx"];
        weakSelf.fileModel.fileName = fileName;
        PreviewViewController* vc = [[PreviewViewController alloc] init];
        vc.filePath = [_fileModel generateFile];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:confirmAction];
    [vc addAction:cancelAction];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)cellContentChanged:(NSString *)content forType:(IRContentType)type{
    switch (type) {
        case IRContentdateString:
            _fileModel.dateString = content;
            break;
        case IRContentsupplier:
            _fileModel.supplier = content;
            break;
        case IRContentPONumber:
            _fileModel.poNumber = content;
            break;
        case IRContentCheckCharger:
            _fileModel.checkCharger = content;
            break;
        case IRContentItemNum:
            _fileModel.itemNum = content;
            [self updateTableViewHeaderText];
            break;
        case IRContentColor:
            _fileModel.color = content;
            [self updateTableViewHeaderText];
            break;
        case IRContentOrderQuantity:
            _fileModel.orderQuantity = content;
            break;
        case IRContentFinishedQuantity:
            _fileModel.finishedQuantity = content;
            break;
        case IRContentInspectedQuantity:
            _fileModel.inspectedQuantity = content;
            break;
        default:
            break;
    }
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return IRContentMAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case IRContentdateString:
        case IRContentsupplier:
        case IRContentPONumber:
        case IRContentCheckCharger:
        case IRContentItemNum:
        case IRContentColor:
        case IRContentOrderQuantity:
        case IRContentFinishedQuantity:
        case IRContentInspectedQuantity:
        case IRContentFrontMarkImageUrl:
        case IRContentSideMarkImageUrl:
        case IRContentAssemblyInstructionImageUrl:
        case IRContentSparePartsImageUrl:
            return 1;
        case IRContentFrontViewImageUrl://front view
            return MIN(2, _fileModel.frontViewImageUrls.count+1);
        case IRContentSideViewImageUrl://side view
            return MIN(2, _fileModel.sideViewImageUrls.count+1);
        case IRContentBackViewImageUrl://back view
            return MIN(2, _fileModel.backViewImageUrls.count+1);
        case IRContentLegViewImageUrl://leg view
            return MIN(2, _fileModel.legViewImageUrls.count+1);
        case IRContentPackageImageUrl://package view
            return MIN(4, _fileModel.packageImageUrls.count+1);
        case IRContentSparePartsPackageImageUrl://spare parts
            return MIN(2, _fileModel.sparePartsPackageImageUrls.count+1);
        case IRContentExtraSparePartsPackageImageUrl://extra spare parts
            return MIN(2, _fileModel.extraSparePartsPackageImageUrls.count+1);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([self cellTypeForIndexPath:indexPath]) {
        case IRCellTypeInput:
            return [IRInputCell cellHeight];
        case IRCellTypeImage:
            return [IRImageCell cellHeight];
        case IRCellTypeAdd:
            return [IRAddActionCell cellHeight];
    }
    return 0;
}

- (IRCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    IRContentType type = indexPath.section;
    if (type <= IRContentInspectedQuantity) {

        return IRCellTypeInput;
    }else{
        BOOL isImageCell = NO;
        
        if(type == IRContentFrontMarkImageUrl){
            if (_fileModel.frontMarkImageUrl.length) {
                isImageCell = YES;
            }
        }else if(type == IRContentSideMarkImageUrl){
            if (_fileModel.sideMarkImageUrl.length) {
                isImageCell = YES;
            }
        }else if(type == IRContentAssemblyInstructionImageUrl){
            if (_fileModel.assemblyInstructionImageUrl.length) {
                isImageCell = YES;
            }
        }else if(type == IRContentSparePartsImageUrl){
            if (_fileModel.sparePartsImageUrl.length) {
                isImageCell = YES;
            }
        }else if(type == IRContentFrontViewImageUrl){
            if (_fileModel.frontViewImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentSideViewImageUrl){
            if (_fileModel.sideViewImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentBackViewImageUrl){
            if (_fileModel.backViewImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentLegViewImageUrl){
            if (_fileModel.legViewImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentPackageImageUrl){
            if (_fileModel.packageImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentSparePartsPackageImageUrl){
            if (_fileModel.sparePartsPackageImageUrls.count > row) {
                isImageCell = YES;
            }
        }else if(type == IRContentExtraSparePartsPackageImageUrl){
            if (_fileModel.extraSparePartsPackageImageUrls.count > row) {
                isImageCell = YES;
            }
        }
        
        if (isImageCell) {
            return IRCellTypeImage;
        }else{
            return IRCellTypeAdd;
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    IRContentType type = indexPath.section;
    RLKBaseTableViewCell* cell = nil;
    NSString* content = nil;
    if (type <= IRContentInspectedQuantity) {
        switch (type) {
            case IRContentdateString:
                content = _fileModel.dateString;
                break;
            case IRContentsupplier:
                content = _fileModel.supplier;
                break;
            case IRContentPONumber:
                content = _fileModel.poNumber;
                break;
            case IRContentCheckCharger:
                content = _fileModel.checkCharger;
                break;
            case IRContentItemNum:
                content = _fileModel.itemNum;
                break;
            case IRContentColor:
                content = _fileModel.color;
                break;
            case IRContentOrderQuantity:
                content = _fileModel.orderQuantity;
                break;
            case IRContentFinishedQuantity:
                content = _fileModel.finishedQuantity;
                break;
            case IRContentInspectedQuantity:
                content = _fileModel.inspectedQuantity;
                break;
            default:
                break;
        }
        cell = [IRInputCell cellWithTableView:tableView];
        
        ((IRInputCell*)cell).content = content;
        ((IRInputCell*)cell).delegate = self;
    }else{
        BOOL isImageCell = NO;
        
        if(type == IRContentFrontMarkImageUrl){
            if (_fileModel.frontMarkImageUrl.length) {
                isImageCell = YES;
                content = _fileModel.frontMarkImageUrl;
            }
        }else if(type == IRContentSideMarkImageUrl){
            if (_fileModel.sideMarkImageUrl.length) {
                isImageCell = YES;
                content = _fileModel.sideMarkImageUrl;
            }
        }else if(type == IRContentAssemblyInstructionImageUrl){
            if (_fileModel.assemblyInstructionImageUrl.length) {
                isImageCell = YES;
                content = _fileModel.assemblyInstructionImageUrl;
            }
        }else if(type == IRContentSparePartsImageUrl){
            if (_fileModel.sparePartsImageUrl.length) {
                isImageCell = YES;
                content = _fileModel.sparePartsImageUrl;
            }
        }else if(type == IRContentFrontViewImageUrl){
            if (_fileModel.frontViewImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.frontViewImageUrls[row];
            }
        }else if(type == IRContentSideViewImageUrl){
            if (_fileModel.sideViewImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.sideViewImageUrls[row];
            }
        }else if(type == IRContentBackViewImageUrl){
            if (_fileModel.backViewImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.backViewImageUrls[row];
            }
        }else if(type == IRContentLegViewImageUrl){
            if (_fileModel.legViewImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.legViewImageUrls[row];
            }
        }else if(type == IRContentPackageImageUrl){
            if (_fileModel.packageImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.packageImageUrls[row];
            }
        }else if(type == IRContentSparePartsPackageImageUrl){
            if (_fileModel.sparePartsPackageImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.sparePartsPackageImageUrls[row];
            }
        }else if(type == IRContentExtraSparePartsPackageImageUrl){
            if (_fileModel.extraSparePartsPackageImageUrls.count > row) {
                isImageCell = YES;
                content = _fileModel.extraSparePartsPackageImageUrls[row];
            }
        }
        
        if (isImageCell) {
            cell = [IRImageCell cellWithTableView:tableView];
            ((IRImageCell*)cell).imageUrl = content;
        }else{
            cell = [IRAddActionCell cellWithTableView:tableView];
        }
    }
    
    
    cell.contentType = type;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case IRContentdateString:
            return @"Date";
        case IRContentsupplier:
            return @"Supplier";
        case IRContentPONumber:
            return @"PO Number";
        case IRContentCheckCharger:
            return @"Checked By";
        case IRContentItemNum:
            return @"Item No";
        case IRContentColor:
            return @"Colour";
        case IRContentOrderQuantity:
            return @"Order Quantity";
        case IRContentFinishedQuantity:
            return @"Finished Quantity";
        case IRContentInspectedQuantity:
            return @"Inspected Quantity";
        case IRContentFrontMarkImageUrl:
            return @"Front of Carton with Shipping Mark";
        case IRContentSideMarkImageUrl:
            return @"Side of Carton with Side Mark";
        case IRContentAssemblyInstructionImageUrl:
            return @"Assembly Instruction";
        case IRContentSparePartsImageUrl:
            return @"Spare Parts";
        case IRContentFrontViewImageUrl://front view
            return @"Front View";
        case IRContentSideViewImageUrl://side view
            return @"Side View";
        case IRContentBackViewImageUrl://back view
            return @"Back View";
        case IRContentLegViewImageUrl://leg view
            return @"LEGS/BASE";
        case IRContentPackageImageUrl://package view
            return @"Product Packaging Photos";
        case IRContentSparePartsPackageImageUrl://spare parts
            return @"Original Spare Parts Packaging Photos";
        case IRContentExtraSparePartsPackageImageUrl://extra spare parts
            return @"Extra Spare Parts Packaging Photos";
    }
    return @"unknown";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self cellTypeForIndexPath:indexPath] == IRCellTypeAdd) {
        _selectImageType = indexPath.section;
        [self showImageSelectionPage];
    }
}

- (void)showImageSelectionPage{
    [self.view endEditing:YES];
    UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"从哪里选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:albumAction];
    [vc addAction:cameraAction];
    [vc addAction:cancelAction];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)takeImageWithSourceType:(UIImagePickerControllerSourceType)type
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = type;
        //先检查相机可用是否
        BOOL cameraIsAvailable = [self checkCamera];
        if (YES == cameraIsAvailable) {
            [self.navigationController presentViewController:picker animated:YES completion:nil];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

- (BOOL)checkCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(AVAuthorizationStatusRestricted == authStatus ||
       AVAuthorizationStatusDenied == authStatus)
    {
        //相机不可用
        return NO;
    }
    //相机可用
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            // 固定方向
////            image = [image fixOrientation];//这个方法是UIImage+Extras.h中方法
//            //压缩图片质量
//            
//            
//            
//        }
        
        CGSize imageSize = image.size;
        imageSize.height = 300;
        imageSize.width = 300;
        //压缩图片尺寸
        image = [self imageWithImageSimple:image scaledToSize:imageSize];
        image = [self reduceImageSize:image];
        //上传到服务器
        //[self doAddPhoto:image];
        [self savePhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//压缩图片质量
-(UIImage *)reduceImageSize:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    double compressedSizeMax = 100 * 1024;
    if (imageData.length > compressedSizeMax) {
        imageData = UIImageJPEGRepresentation(image, compressedSizeMax/imageData.length);
    }
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//获取tmp目录
-(NSString *)tmpDirectory{
    
    return NSTemporaryDirectory();
}

- (void)savePhoto:(UIImage*)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    NSString* fileName = [NSString stringWithFormat:@"image%@-%05d.png",[[NSDate date] M_d_DateString],arc4random()%100000];
    NSString* filePath = [[self tmpDirectory] stringByAppendingString:fileName];
    NSData* imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:filePath options:NSDataWritingAtomic error:nil];
    switch (_selectImageType) {
        case IRContentFrontMarkImageUrl:
            _fileModel.frontMarkImageUrl = filePath;
            break;
        case IRContentSideMarkImageUrl:
            _fileModel.sideMarkImageUrl = filePath;
            break;
        case IRContentAssemblyInstructionImageUrl:
            _fileModel.assemblyInstructionImageUrl = filePath;
            break;
        case IRContentSparePartsImageUrl:
            _fileModel.sparePartsImageUrl = filePath;
            break;
        case IRContentFrontViewImageUrl://front view
            [_fileModel.frontViewImageUrls addObject:filePath];
            break;
        case IRContentSideViewImageUrl://side view
            [_fileModel.sideViewImageUrls addObject:filePath];
            break;
        case IRContentBackViewImageUrl://back view
            [_fileModel.backViewImageUrls addObject:filePath];
            break;
        case IRContentLegViewImageUrl://leg view
            [_fileModel.legViewImageUrls addObject:filePath];
            break;
        case IRContentPackageImageUrl://package view
            [_fileModel.packageImageUrls addObject:filePath];
            break;
        case IRContentSparePartsPackageImageUrl://spare parts
            [_fileModel.sparePartsPackageImageUrls addObject:filePath];
            break;
        case IRContentExtraSparePartsPackageImageUrl://extra spare parts
            [_fileModel.extraSparePartsPackageImageUrls addObject:filePath];
            break;
        default:
            break;
    }
    [self.tableView reloadData];

}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error){
        NSString *msg = @"保存图片到相册失败" ;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }

}

@end
