//
//  UploadViewController.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/12.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "UploadViewController.h"
#import "FileManager.h"
#import <MBProgressHUD.h>
@interface UploadViewController ()
{
    NSData *zipData;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *jiegou;
@property (weak, nonatomic) IBOutlet UILabel *dongshu;
@property (weak, nonatomic) IBOutlet UILabel *mianji;
@property (weak, nonatomic) IBOutlet UILabel *xiaofang;
@property (weak, nonatomic) IBOutlet UILabel *UM;
@property (weak, nonatomic) IBOutlet UILabel *zipName;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong,nonatomic) NSDictionary   *params;

@end

@implementation UploadViewController
-(instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        _params = params;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离线上传";
    [self creatNavi];
    [self loadInfoData];
}

-(void)creatNavi
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20, 45,44);
    
    UIImage *image = [UIImage imageNamed:@"back"];
    //    image = [image imageWithColor:[UIColor blackColor]];
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:kNetworkType style:UIBarButtonItemStylePlain target:self action:@selector(noAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
}
-(void)loadInfoData
{
    _UM.text = [NSString stringWithFormat:@"UM编号：%@",_params[@"code"]];
    _name.text = [NSString stringWithFormat:@"商机名称：%@",_params[@"name"]];
    _address.text = [NSString stringWithFormat:@"定位地址：%@",_params[@"local"]];
    _jiegou.text = [NSString stringWithFormat:@"建筑结构：%@",_params[@"jiegou"]];
    _dongshu.text = [NSString stringWithFormat:@"房屋栋数：%@",_params[@"dongshu"]];
    _mianji.text = [NSString stringWithFormat:@"最大面积：%@",_params[@"mianji"]];
    _xiaofang.text = [NSString stringWithFormat:@"消防设备：%@",_params[@"xiaofang"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        zipData = [FileManager zipData:_params object:self];
    });
    _zipName.text = [FileManager getDataName:_params];
}

-(void)noAction
{
    
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)uploadAction:(id)sender
{
    [self upload:_params];
    
}
#pragma mark netWork
-(void)upload:(NSDictionary*)dict{
    if (!zipData) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"文件压缩失败" afterDelay:1 isTouched:YES inView:nil];
        return;
    }
    //    NSMutableDictionary *item = [self.params mutableCopy];
    //    [item setValue:@"已上传" forKey:@"state"];
    //    [FileManager addItem:item];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSuccess" object:nil];
    //    MBProgressHUD *HUD = [DFYGProgressHUD showProgressHUDWithText:@"" isTouched:YES inView:self.view progressTintColor:[UIColor blackColor]];
    //    __block MBProgressHUD * weakHUD = HUD;
    //    __weak UploadViewController *weakSelf = self;
    
    NSMutableDictionary *params = [dict mutableCopy];
    [params removeObjectForKey:@"fileId"];
    [params setObject:@"file" forKey:@"fname"];
    [params removeObjectForKey:@"state"];
    [params setObject:zipData forKey:@"file"];
    //    [[NetWorkManager sharedInstance]requestDataForPOSTWithURL:uploadUrl parameters:params Controller:nil success:^(id responseObject) {
    //        NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@",resultStr);
    //        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:resultStr afterDelay:5 isTouched:YES inView:nil];
    //
    //    } failure:^(NSError *error) {
    //        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:error.description afterDelay:5 isTouched:YES inView:nil];
    //
    //    }];
    [[NetWorkManager sharedInstance]updateFile:@[zipData] url:uploadUrl parameters:[dict mutableCopy] viewControler:nil progressBlock:^(NSProgress * _Nonnull uploadProgress) {
        
        CGFloat progress = (1 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        NSLog(@"%f",progress);
        
    } success:^(id result) {
        //        [weakSelf.params setValue:@"已上传" forKey:@"state"];
        //        [FileManager addItem:self.params];
        NSString *resultStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultStr);
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:resultStr afterDelay:2 isTouched:YES inView:nil];
        //        NSLog(@"upload success!");
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
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
