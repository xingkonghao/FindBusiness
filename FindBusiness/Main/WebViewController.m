//
//  WebViewController.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/3.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "WebViewController.h"
#import "LoginView.h"
#import "EmptyView.h"
#import "ZFDownloadViewController.h"
#import "BusinessManagerViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    BOOL isLogin;
    BOOL isMenuShow;
    
    BOOL test;
}
@property (strong, nonatomic)  UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *leftMenu;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *UMCode;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *businessBtn;
@property (weak, nonatomic) IBOutlet UIButton *dowloadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrant;
@property (nonatomic, strong)UIControl *hiddenControl;
@property (nonatomic,strong)EmptyView *emptyView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商机管理";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self checkLogin];
    [self setupView];                                                            
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
#pragma mark 主页面模块

-(void)checkLogin
{
    NSUserDefaults *userManager = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userManager objectForKey:@"userInfo"];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        self.userName.text = userInfo[@"username"];
        self.UMCode.text = userInfo[@"UM"];
        isLogin = YES;
    }
}
-(void)deleteUserInfo
{
    NSUserDefaults *userManager = [NSUserDefaults standardUserDefaults];
    [userManager removeObjectForKey:@"userInfo"];
    [userManager synchronize];
}

-(void)setupView
{
    [self creatNavi];
    if (isLogin) {
        [self loadWebView:self.userName.text];

    }else
    {
        [self.view addSubview:self.emptyView];
    }

}

-(UIWebView*)webView
{
    if (!_webView) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        webView.delegate = self;
//        webView.scrollView.scrollEnabled = NO;
        webView.scalesPageToFit = YES;
//        [self.view addSubview:_webView];stringByAddingPercentEscapesUsingEncoding
        _webView = webView;
        [self.view insertSubview:_webView belowSubview:self.leftMenu];
    }
    return _webView;
}
-(void)loadWebView:(NSString*)userName
{
    NSString* url = [[NSString stringWithFormat:@"%@%@",webUrl,userName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.webView.delegate   = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}

-(void)creatNavi
{
    
    UIButton *showMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    showMenu.frame = CGRectMake(0, 0, 40, 40);
    [showMenu setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [showMenu addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:showMenu];
    
    self.leftMenu.layer.shadowOffset = CGSizeMake(2, 2);
    self.leftMenu.layer.shadowColor = [UIColor blackColor].CGColor;
    self.leftMenu.layer.masksToBounds = NO;
    self.leftMenu.layer.shadowOpacity = 0.5;
    self.leftMenu.layer.shadowRadius = 2;
    
}
-(EmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        _emptyView.reminderLab.text = @"未登录";
    }
    return _emptyView;
}
#pragma mark 登录模块
-(void)creatLoginView
{
    LoginView *loginView = [[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:nil].lastObject;
    loginView.frame = kScreenBounds;
    [loginView compeleteHandler:^(NSString *userName,NSString*um) {
        if (userName) {
            isLogin = YES;
            self.userName.text = userName;
            self.UMCode.text = um;
            [self loadWebView:userName];
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        [loginView removeFromSuperview];
    }];
    [self.view.window addSubview:loginView];
}
-(UIControl*)hiddenControl
{
    if (!_hiddenControl) {
        UIControl *hiddenControl = [[UIControl alloc]initWithFrame:CGRectMake(200, 0, self.view.frame.size.width-200, self.view.frame.size.height)];
        hiddenControl.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [hiddenControl addTarget:self action:@selector(hiddenMenu) forControlEvents:UIControlEventAllEvents];
        _hiddenControl = hiddenControl;
        
    }
    return  _hiddenControl;
}
#pragma mark 左侧滑栏模块
-(void)showMenu:(UIButton*)btn{
    if (isLogin) {
        if (!isMenuShow) {
            isMenuShow = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.leftConstrant.constant = 0;
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                [self.view addSubview:self.hiddenControl];
            }];
        }else
        {
            [self hiddenMenu];
        }
    }else
    {
        [self creatLoginView];
    }
}
-(void)hiddenMenu
{
    isMenuShow = NO;
    [self.hiddenControl removeFromSuperview];
    self.hiddenControl = nil;
    [UIView animateWithDuration:0.5 animations:^{
        self.leftConstrant.constant = -205;
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished) {
    }];
}
- (IBAction)exitAction:(id)sender {
    isLogin = NO;
    [self hiddenMenu];
    [self.webView removeFromSuperview];
    self.webView  = nil;
    [self.view addSubview:self.emptyView];
    [self deleteUserInfo];
}
- (IBAction)businessAction:(id)sender {
    BusinessManagerViewController *vc = [BusinessManagerViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)dowloadAction:(id)sender {
    ZFDownloadViewController *vc = [[ZFDownloadViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeActivityIndicator withText:@"加载中" isTouched:YES inView:self.view];
    NSLog(@"web***开始");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DFYGProgressHUD hideProgressHUDAfterDelay:0];
    NSLog(@"web****结束");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [DFYGProgressHUD hideProgressHUDAfterDelay:0];
    NSLog(@"web****失败%@",error.description);
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    NSLog(@"web****即将开始");

    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"PDF"].location != NSNotFound) {
      
//        url =test?@"http://v2.topu.com/course/201611/y8hdAiDn7H.mp4":@"http://v2.topu.com/course/201611/T6jnna3JBx.mp4";
//       
//        test = !test;
        NSString *name = [[url componentsSeparatedByString:@"/"] lastObject];
        UIWebView *web = [[UIWebView alloc] init];
        
        NSString *sc = [NSString stringWithFormat:@"decodeURIComponent('%@')",name];
        
        NSString *st = [web stringByEvaluatingJavaScriptFromString:sc];
        
        [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:st fileimage:nil];
        // 设置最多同时下载个数（默认是3）
        [ZFDownloadManager sharedDownloadManager].maxCount = 2;

//        [[DownloadManager shareManager]addNewDownloadTask:url];
        ZFDownloadViewController *vc = [[ZFDownloadViewController alloc]init];
//        DownloadVC *vc = [[DownloadVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeActivityIndicator withText:@"加载中" isTouched:YES inView:self.view];

    return YES;
}
@end
