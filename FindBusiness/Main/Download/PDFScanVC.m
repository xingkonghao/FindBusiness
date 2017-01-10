//
//  PDFScanVC.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/6.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "PDFScanVC.h"
#import <Messages/Messages.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PDFScanVC ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,weak)IBOutlet UIWebView *web;
@property (nonatomic,strong)ZFFileModel *model;
@end

@implementation PDFScanVC
-(instancetype)initWithFilePath:(ZFFileModel *)model
{
    if (self = [super  init]) {
        _model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DPF浏览";
    
    [self creatNavi];
    NSString *filePath = FILE_PATH(_model.fileName);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    _web.delegate = self;
    [_web loadRequest:request];
}
-(void)creatNavi
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20, 45,44);
    
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithColor:[UIColor blackColor]];
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(10,20, 45,44);
    
    UIImage *image1 = [UIImage imageNamed:@"abc_ic_menu_share_mtrl_alpha"];
    image1 = [image1 imageWithColor:[UIColor blackColor]];

    [share setImage:image1 forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:share];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)share
{
    NSString *filePath = FILE_PATH(_model.fileName);
    
    NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
    UIActivityViewController *activeVC = [[UIActivityViewController alloc]initWithActivityItems:@[@" ",pdfData] applicationActivities:nil];
//    activeVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
//                                                     UIActivityTypePrint];
    [self presentViewController:activeVC animated:YES completion:nil];
    activeVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed,
                                                          NSArray *returnedItems, NSError *activityError) {
        if (!activityError && completed) {
//            [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"发送成功" afterDelay:1 isTouched:YES inView:nil];
        }
        // 分享完成或退出分享时调用该方法
        NSLog(@"分享完成");
    };
//    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
//    if(mailCompose)
//    {
//        //设置代理
//        [mailCompose setMailComposeDelegate:self];
//        
//        NSArray *toAddress = [NSArray arrayWithObject:@"98zg@sina.cn"];
//        NSArray *ccAddress = [NSArray arrayWithObject:@"17333245@qq.com"];;
//        NSString *emailBody = @"<H1>日志信息</H1>";
//        
//        //设置收件人
////        [mailCompose setToRecipients:toAddress];
////        //设置抄送人
////        [mailCompose setCcRecipients:ccAddress];
//        //设置邮件内容
//        [mailCompose setMessageBody:emailBody isHTML:YES];

//        //设置邮件主题
//        [mailCompose setSubject:@"这里是主题"];
//        //设置邮件附件{mimeType:文件格式|fileName:文件名}
//        [mailCompose addAttachmentData:pdfData mimeType:@"pdf" fileName:_model.fileName];
//        //设置邮件视图在当前视图上显示方式
////        [self presentModalViewController:mailCompose animated:YES];
//        [self presentViewController:mailCompose animated:YES completion:nil];
//    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
