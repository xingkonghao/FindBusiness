//
//  DownloadVC.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "DownloadVC.h"
#import "BaseSliderController.h"
#import "DownloadChildVC.h"
@interface DownloadVC ()<SliderDelegate>

@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseSliderController *bvc = [[BaseSliderController alloc] init];
    bvc.delegate = self;
    bvc.topBtnWidth = SCREEN_WIDTH/4.0;
    bvc.topTitles = @[@"下载中", @"已下载"];
    bvc.sliderWidth = SCREEN_WIDTH/4.0;

    bvc.view.frame = self.view.bounds;
    
    DownloadChildVC *vc1 = [[DownloadChildVC alloc] initWithType:0];
    vc1.view.backgroundColor = [UIColor redColor];
    DownloadChildVC *vc2 = [[DownloadChildVC alloc] initWithType:1];
    vc2.view.backgroundColor = [UIColor greenColor];
    bvc.sliderViewControllers = @[vc1, vc2];
    
    [self.view addSubview:bvc.view];
    [self addChildViewController:bvc];
 
    [bvc didMoveToParentViewController:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
