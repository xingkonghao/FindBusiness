//
//  DownloadVC.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "DownloadVC.h"
#import "BaseSliderController.h"
#import "ZFDownloadViewController.h"
@interface DownloadVC ()<SliderDelegate>
{
    NSInteger _currentIndex;
}
@end

@implementation DownloadVC
-(instancetype)initWithIndex:(NSInteger)index;
{
    if (self = [super init]) {
        _currentIndex = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavi];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    BaseSliderController *bvc = [[BaseSliderController alloc] init];
    bvc.delegate = self;
    bvc.topBtnWidth = SCREEN_WIDTH/4.0;
    bvc.topTitles = @[@"已下载", @"下载中"];
    bvc.sliderWidth = SCREEN_WIDTH/4.0;

    bvc.view.frame = self.view.bounds;
    
    ZFDownloadViewController *vc1 = [[ZFDownloadViewController alloc] initWithType:0];
    vc1.view.backgroundColor = [UIColor redColor];
    ZFDownloadViewController *vc2 = [[ZFDownloadViewController alloc] initWithType:1];
    vc2.view.backgroundColor = [UIColor greenColor];
    bvc.sliderViewControllers = @[vc1, vc2];

    [self.view addSubview:bvc.view];
    [self addChildViewController:bvc];
 
    [bvc didMoveToParentViewController:self];
    
    self.navigationItem.titleView = bvc.topView;
   
    bvc.currentIndex = _currentIndex;
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
-(void)noAction
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)segementSelect:(UISegmentedControl*)segement
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
