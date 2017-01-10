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
#define BusinessCellID  @"BusinessCell"
#import "FileManager.h"
@interface BusinessManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView *tab;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)MenuView *menuView;
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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(UIView*)menuView
{
    if (_menuView == nil) {
        _menuView = [MenuView initWith:self CompleteHandler:^(NSInteger index) {
            switch (index) {
                case 1:
                {
                }
                    break;
                case 2 :
                {
                
                }break;
                case 3 :
                {
                    TakePhotoViewController *takeVC = [[TakePhotoViewController alloc]initWithParams:_menuView.params];
                    [self presentViewController:takeVC animated:YES completion:nil];
                }break;
                case 4 :
                {
                    
                }break;

                default:
                    break;
            }
            _menuView.hidden = YES;
        }];
        _menuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self.view.window addSubview:_menuView];
    }
    _menuView.hidden = NO;
    return _menuView;
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
    [self.tab reloadData];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建商机" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewBusiness)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}
-(void)creatNewBusiness
{
    CreatBusinessVC *vc = [[CreatBusinessVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
//    self.menuView.params = _dataArr[indexPath.row];
//    self.menuView.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark netWork
-(void)upload
{
    [NetWorkManager sharedInstance];
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
