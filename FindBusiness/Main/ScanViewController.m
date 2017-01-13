//
//  ScanViewController.m
//  
//
//  Created by 星空浩 on 2017/1/9.
//
//
#define MARGIN 10
#define COL 4
#define kWidth [UIScreen mainScreen].bounds.size.width
#import "AlbumCollectionCell.h"
#import "ScanViewController.h"
#import "FileManager.h"
#import "EmptyView.h"
#import "ScanViewHeader.h"
static NSString * const reuseIdentifier = @"AlbumCollectionCell";

@interface ScanViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *UM;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *jiegou;
@property (weak, nonatomic) IBOutlet UILabel *dongshu;
@property (weak, nonatomic) IBOutlet UILabel *mianji;
@property (weak, nonatomic) IBOutlet UILabel *xiaofang;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSArray *sectionTitles;
@property (nonatomic,strong)EmptyView *emptyView;
@end

@implementation ScanViewController
-(instancetype)initWithParams:(NSDictionary*)dict;
{
    if (self  = [super init]) {
        _dict = dict;
      
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavi];
    self.title = _dict[@"name"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = MARGIN;
    flowLayout.minimumInteritemSpacing = MARGIN;
    CGFloat cellHeight = (kWidth - (COL + 1) * MARGIN) / COL;
    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ScanViewHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScanViewHeader"];
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
    
}
-(EmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 200,SCREEN_WIDTH, SCREEN_HEIGHT-64-150)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        _emptyView.remiderInfo = @"该勘查目录下没有任何图片";
    }
    return _emptyView;
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadInfoData
{
    _UM.text = [NSString stringWithFormat:@"UM编号：%@",_dict[@"code"]];
    _name.text = [NSString stringWithFormat:@"商机名称：%@",_dict[@"name"]];
    _address.text = [NSString stringWithFormat:@"定位地址：%@",_dict[@"local"]];
    _jiegou.text = [NSString stringWithFormat:@"建筑结构：%@",_dict[@"jiegou"]];
    _dongshu.text = [NSString stringWithFormat:@"房屋栋数：%@",_dict[@"dongshu"]];
    _mianji.text = [NSString stringWithFormat:@"最大面积：%@",_dict[@"mianji"]];
    _xiaofang.text = [NSString stringWithFormat:@"消防设备：%@",_dict[@"xiaofang"]];
    _sectionTitles = [FileManager getCategotysUnderBusiness:_dict[@"name"]];
    if (_sectionTitles.count==0) {
        [self.view addSubview:self.emptyView];
    }
    [self.collectionView reloadData];
   
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionTitles.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NSArray *filePaths =  [FileManager getitemUnderCategory:_sectionTitles[section] businessName:_dict[@"name"]];

    return filePaths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    NSArray *filePaths =  [FileManager getitemUnderCategory:_sectionTitles[indexPath.section] businessName:_dict[@"name"]];
    NSString *filePath = [FileManager  getdataPath:filePaths[indexPath.row] category:_sectionTitles[indexPath.section] businessName:_dict[@"name"]];
    cell.img.image = [UIImage imageWithContentsOfFile:filePath];
//    AssetModel *model = self.assetModels[indexPath.row];
//    cell.img.image = model.thumbnail;
//    cell.indexPath = indexPath;
//    cell.delegate = self;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = (kWidth - (COL + 1) * MARGIN) / COL;

    return CGSizeMake(cellHeight, cellHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MARGIN;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return MARGIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ScanViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScanViewHeader" forIndexPath:indexPath];
        header.titleLab.text = _sectionTitles[indexPath.section];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake(SCREEN_WIDTH, 30);
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
