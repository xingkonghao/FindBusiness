//
//  ZFDownloadViewController.m
//  ZFDownload
//
//  Created by 任子丰 on 16/5/16.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "ZFDownloadViewController.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"
#import "UIImage+Color.h"
#import "PDFScanVC.h"
#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface ZFDownloadViewController ()<ZFDownloadDelegate,UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView;

@property (atomic, strong) NSMutableArray *downloadObjectArr;

@end

@implementation ZFDownloadViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 更新数据源
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavi];
    self.title = @"下载管理";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.tableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFDownloadedCell" bundle:nil] forCellReuseIdentifier:@"ZFDownloadedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFDownloadingCell" bundle:nil] forCellReuseIdentifier:@"ZFDownloadingCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    DownloadManager.downloadDelegate = self;
    //NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
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
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData
{
    [DownloadManager startLoad];
    NSMutableArray *downladed = DownloadManager.finishedlist;
    NSMutableArray *downloading = DownloadManager.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    [self.tableView reloadData];
}

/** 全部开始 */
- (IBAction)startAll:(UIBarButtonItem *)sender {
    [DownloadManager startAllDownloads];
}

/** 全部暂停 */
- (IBAction)pauseAll:(UIBarButtonItem *)sender {
    [DownloadManager pauseAllDownloads];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.downloadObjectArr[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadedCell"];
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        return cell;
    } else if (indexPath.section == 1) {
        ZFDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadingCell"];
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            [weakSelf initData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        PDFScanVC *vc = [[PDFScanVC alloc]initWithFilePath:fileInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteFinishFile:fileInfo];
    }else if (indexPath.section == 1) {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"下载完成",@"下载中"][section];
}

#pragma mark - ZFDownloadDelegate

// 开始下载
- (void)startDownload:(ZFHttpRequest *)request
{
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request
{
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo
{
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[ZFDownloadingCell class]]) {
            ZFDownloadingCell *cell = (ZFDownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

@end

