//
//  PreviewViewController.m
//  InsepcetionReport
//
//  Created by Realank on 2017/6/15.
//  Copyright © 2017年 Realank. All rights reserved.
//

#import "PreviewViewController.h"


@interface PreviewViewController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *irWebView;
@property (nonatomic, strong) UIDocumentInteractionController *documentIc;
@property (nonatomic, weak) UIBarButtonItem* item;
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFile)];
    item.enabled = YES;
    [self.navigationItem setRightBarButtonItem:item];
    _item = item;
    
    NSURL *url = [NSURL fileURLWithPath:_filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_irWebView loadRequest:request];
}

- (void)shareFile{
    // 调用safari分享功能将文件分享出去

    UIDocumentInteractionController *documentIc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_filePath]];
    
    // 记得要强引用UIDocumentInteractionController,否则控制器释放后再次点击分享程序会崩溃
    self.documentIc = documentIc;
    
    // 如果需要其他safari分享的更多交互,可以设置代理
    documentIc.delegate = self;
    
//    documentIc.UTI = @"com.microsoft.xlsx";//You need to set the UTI (Uniform Type Identifiers) for the documentController object so that it can help the system find the appropriate application to open your document. In this case, it is set to “com.adobe.pdf”, which represents a PDF document. Other common UTIs are "com.apple.quicktime-movie" (QuickTime movies), "public.html" (HTML documents), and "public.jpeg" (JPEG files)
    
    // 设置分享显示的矩形框
    CGRect rect = CGRectMake(0, 0, 300, 300);
    [documentIc presentOpenInMenuFromRect:rect inView:self.navigationController.view animated:YES];
    [documentIc presentPreviewAnimated:YES];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

@end
