//
//  BusinessManagerViewController.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/9.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "BusinessManagerViewController.h"
#import "CreatBusinessVC.h"
#import "BusinessCell.h"
#import "FileManager.h"
#import "MenuView.h"
#import "TakePhotoViewController.h"
#import "ScanViewController.h"
#define BusinessCellID  @"BusinessCell"
#import "FileManager.h"
#import <ZipArchive.h>
#import "ExampleView.h"
#import "EmptyView.h"
#import "UploadViewController.h"
@interface BusinessManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ZipArchiveDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ZipArchive *zip;
    NSDictionary *tempDict;
}
@property(nonatomic,weak)IBOutlet UITableView *tab;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)MenuView *menuView;
@property (nonatomic,strong)UIView *scanView;;
@property (nonatomic,strong)EmptyView *emptyView;
@end

@implementation BusinessManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"个人商机";
    self.dataArr = [NSMutableArray array];
    _tab.tableFooterView = [[UIView alloc]init];
    [_tab registerNib:[UINib nibWithNibName:BusinessCellID bundle:nil] forCellReuseIdentifier:BusinessCellID];
    [self creatNavi];
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReload) name:@"BusinessReload" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReload) name:@"uploadSuccess" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(EmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        _emptyView.remiderInfo = @"目前还没有创建任何商机";
    }
    return _emptyView;
}
-(UIView*)menuView
{
    if (_menuView == nil) {
        _menuView = [MenuView initWith:self CompleteHandler:^(NSInteger index) {
            _menuView.hidden = YES;
            switch (index) {
                case 1:
                {
                    if ([_menuView.params[@"state"] isEqualToString:@"已上传"]) {
                        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"上传后不能修改" afterDelay:1.5 isTouched:YES inView:nil];
                        break ;
                    }

                    UploadViewController *vc = [[UploadViewController alloc]initWithParams:_menuView.params];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2 :
                {
                    if ([_menuView.params[@"state"] isEqualToString:@"已上传"]) {
                        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"上传后不能修改" afterDelay:1.5 isTouched:YES inView:nil];
                        break ;
                    }

                    CreatBusinessVC *vc = [[CreatBusinessVC alloc]initWithDict:_menuView.params];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                case 3 :
                {
                    if ([_menuView.params[@"state"] isEqualToString:@"已上传"]) {
                        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"上传后不能修改" afterDelay:1.5 isTouched:YES inView:nil];
                        break ;
                    }
                    tempDict = _menuView.params;
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
//                    self.scanView.hidden = NO;
                }break;
                case 4 :
                {
                    ScanViewController *vc = [[ScanViewController alloc]initWithParams:_menuView.params];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;

                default:
                    break;
            }
        }];
        _menuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self.view.window addSubview:_menuView];
    }
    _menuView.hidden = NO;
    return _menuView;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
//    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取图片裁剪的图
//    UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
//    //获取图片裁剪后，剩下的图
//    UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
//    //获取图片的url
//    NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
//    //获取图片的metadata数据信息
//    NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    NSData *imageData = UIImageJPEGRepresentation(original, 1);
    [FileManager writeData:imageData toDiskWithBusinessName:tempDict[@"name"] category:@"大门及周边"];
    //模态方式退出uiimagepickercontroller
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker dismissModalViewControllerAnimated:YES];
}
-(UIView*)scanView
{
    if (_scanView==nil) {
        _scanView = [[UIView alloc]initWithFrame:self.view.bounds];
        _scanView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [self.view addSubview:_scanView];
        
        ExampleView *view = [ExampleView loadNibWithFrme:CGRectMake(30, 30, _scanView.frame.size.width-60, _scanView.frame.size.height-100) action:^(BOOL isgoOn) {
            if (isgoOn) {
                TakePhotoViewController *takeVC = [[TakePhotoViewController alloc]initWithParams:_menuView.params];
                [self presentViewController:takeVC animated:YES completion:nil];

            }
            _scanView.hidden = YES;
        }];
        [_scanView addSubview:view];
        
    }
    _scanView.hidden = NO;
    return _scanView;
}
-(void)zipData:(NSDictionary*)item
{
    [self upload:item data:[FileManager zipData:item object:self]];

}
-(BOOL)OverWriteOperation:(NSString *)file
{
    
    return YES;
}
-(void)ErrorMessage:(NSString *)msg
{
    NSLog(@"%@",msg);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];


}
-(void)dataReload
{
    [self initData];
}
-(void)initData
{
    
    self.dataArr = [NSMutableArray arrayWithArray:[FileManager getItems]];
    if (self.dataArr.count==0) {
        [self.view addSubview:self.emptyView];
        return;
    }
    self.emptyView.hidden = YES;
    [self.tab reloadData];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建商机" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewBusiness)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatNewBusiness
{
    CreatBusinessVC *vc = [[CreatBusinessVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:BusinessCellID];
    [cell bind:self.dataArr[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FileManager 
//    UIImage *image = [UIImage imageNamed:@"demo_dmjzb"];
//    NSDictionary *dic = self.dataArr[indexPath.row];
//    [manager writeImageToDisk:UIImageJPEGRepresentation(image, 1) businessName:dic[@"name"] catogoryname:@"周边"];
    self.menuView.params = _dataArr[indexPath.row];
    self.menuView.hidden = NO;
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [FileManager deleteItem:self.dataArr[indexPath.row]];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark netWork
-(void)upload:(NSDictionary*)dict data:(NSData*)zipData
{
   
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
