//
//  BaseNaviController.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/3.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "BaseNaviController.h"

@interface BaseNaviController ()

@end

@implementation BaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationBar setBarTintColor:[UIColor colorWithRed:253/255.0 green:152/255.0 blue:38/255.0 alpha:1]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
