//
//  DownloadChildVC.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "DownloadChildVC.h"
#import "DownloadCell.h"
#import "FileManager.h"
#import "DownloadManager.h"
#define DownloadCellID  @"DownloadCell"
@interface DownloadChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tabView;
@property(nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)FileManager *manager;
@end

@implementation DownloadChildVC
-(instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.type = type;
        [self initData];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.type==1) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"CompleteReload" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"unCompleteReload" object:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)initData
{
    self.dataArr = [NSMutableArray array];
    self.manager = [[FileManager alloc]init];
    [self getDataFromPlist];
//    if (self.type == 0) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"CompleteReload" object:nil];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[_manager getDownLoadPath],@"complete.plist"];
//        self.dataArr = [self.manager getDictWithFilePath:filePath];
//    }else
//    {
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[_manager getDownLoadPath],@"uncomplete.plist"];
//        self.dataArr = [self.manager getDictWithFilePath:filePath];
//        
    
//        [[DownloadManager shareManager]completeHandler:^(NSDictionary *model) {
//            NSInteger count = self.dataArr.count;
//            for (int i = 0;i<count;i++) {
//                NSDictionary *tpModel = self.dataArr[i];
//                if ([tpModel[@"url"] isEqualToString:model[@"url"]]) {
//                    NSInteger index = [self.dataArr indexOfObject:tpModel];
//                    [[DownloadManager shareManager]removeDownloadTask:index];
//                    [DownloadManager shareManager];
//                    [self.dataArr removeObjectAtIndex:index];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.tabView reloadData];
//                    });
//                }
//            }
//        }];
//        
//    }
}
-(UITableView*)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        [_tabView registerNib:[UINib nibWithNibName:DownloadCellID bundle:nil] forCellReuseIdentifier:DownloadCellID];
    }
    return _tabView;
}
-(void)reloadData
{
    [self getDataFromPlist];

    [self.tabView reloadData];
}
-(void)getDataFromPlist
{
    NSString *filePath = nil;
    if (_type==1) {

        filePath = [NSString stringWithFormat:@"%@/%@",[_manager getDownLoadPath],@"complete.plist"];
        
        
    }else
    {

       filePath = [NSString stringWithFormat:@"%@/%@",[_manager getDownLoadPath],@"uncomplete.plist"];
        
        [[DownloadManager shareManager]getProgress:^(NSProgress *downloadProgress, NSDictionary *model) {
            NSInteger count = self.dataArr.count;
            for (int i = 0;i<count;i++) {
                NSDictionary *tpModel = self.dataArr[i];
                if ([tpModel[@"url"] isEqualToString:model[@"url"]]) {
                    [tpModel setValue:[NSString stringWithFormat:@"%lld",downloadProgress.totalUnitCount] forKeyPath:@"totalUnitCount"];
                    [tpModel setValue:[NSString stringWithFormat:@"%lld",downloadProgress.completedUnitCount] forKeyPath:@"completedUnitCount"];
                    
                    NSInteger index = [self.dataArr indexOfObject:tpModel];
                    //                    [self.dataArr replaceObjectAtIndex:index withObject:model];
                    [self.dataArr replaceObjectAtIndex:index withObject:tpModel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tabView reloadData];
                    });
                }
            }
        }];
        
    }
    self.dataArr = [self.manager getDictWithFilePath:filePath];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:DownloadCellID];
    if (self.dataArr.count>indexPath.row) {
        NSDictionary *model = self.dataArr[indexPath.row];
        cell.backgroundColor = [UIColor redColor];
        [cell bind:model];
    }
    return cell;
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
