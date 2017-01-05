//
//  BaseSliderController.m
//  lixy
//
//  Created by  星空浩818 on 14/10/28.
//  Copyright (c) 2014年  星空浩818. All rights reserved.
//

#import "BaseSliderController.h"
#import "BaseScrollView.h"
#define TopBtnHeight 35.0
#define SliderViewHeight 2.0
#define TopViewHeight 64.0
@interface BaseSliderController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation BaseSliderController

@synthesize contentScrollView = _contentScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setSliderViewControllers:(NSArray *)sliderViewControllers
{
    _currentIndex = -1;
    _sliderViewControllers = sliderViewControllers;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.contentScrollView];
    
    NSInteger count = _sliderViewControllers.count;
    
    UIButton *firstBtn = nil;
    
    for (int i=0; i<count; i++) {
        
        UIViewController *baseVC = _sliderViewControllers[i];
        baseVC.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.contentScrollView.frame.size.height);
        baseVC.view.clipsToBounds = YES;
        [self addChildViewController:baseVC];
        [self.contentScrollView addSubview:baseVC.view];
        [baseVC didMoveToParentViewController:self];
        
        baseVC.navigationItem.title = _topTitles[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_topBtnWidth*i + SCREEN_WIDTH/4.0, 20, _topBtnWidth, TopBtnHeight);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitle:_topTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.tag = i+1;
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            firstBtn = btn;
            btn.backgroundColor = [UIColor darkGrayColor];
        }
        [self.topView addSubview:btn];
    }
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*_sliderViewControllers.count, self.contentScrollView.frame.size.height)];
    
    
//    _slideView = [[UIView alloc] initWithFrame:CGRectMake((_topBtnWidth-_sliderWidth)/2.0, TopBtnHeight, _sliderWidth, SliderViewHeight)];
//    _slideView.backgroundColor = MainColor;
//    [self.topView addSubview:_slideView];

    [self topBtnClick:firstBtn];
}

- (void)topBtnClick:(UIButton*)btn
{
    if (btn.selected) {
        return;
    } else {
        
        UIViewController *vc = _sliderViewControllers[btn.tag-1];
        [vc viewWillAppear:YES];
        
        if (_currentIndex>=0) {
            UIViewController *vc2 = _sliderViewControllers[_currentIndex];
            [vc2 viewWillDisappear:YES];
        }
        
    }
    
    for (int i=0; i<_sliderViewControllers.count; i++) {
        UIButton *button = (UIButton*)[self.topView viewWithTag:i+1];
        button.selected = NO;
        button.backgroundColor = [UIColor lightGrayColor];
    }
    
    _currentIndex = btn.tag - 1;
    
    btn.selected = YES;
    btn.backgroundColor = [UIColor darkGrayColor];
    [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(btn.tag-1), 0) animated:YES];

    [UIView animateWithDuration:0.3 animations:^{
        _slideView.centerX = btn.centerX;
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        
        NSInteger index = (scrollView.contentOffset.x + 10)/SCREEN_WIDTH;
        
        UIButton *button = (UIButton*)[self.topView viewWithTag:index+1];
        [self topBtnClick:button];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging || scrollView.isDecelerating) {
        self.slideView.left = scrollView.contentOffset.x / self.topTitles.count;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        
        NSInteger index = (scrollView.contentOffset.x + 10)/SCREEN_WIDTH;
        
        UIButton *button = (UIButton*)[self.topView viewWithTag:index+1];
        [self topBtnClick:button];
        
    }
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
        _topView.backgroundColor = MainColor;
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, TopViewHeight-1, SCREEN_WIDTH/2.0, 1)];
//        view.backgroundColor = [UIColor colorWithHex:0xcccccc];
//        [_topView addSubview:view];
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10,20, 45,44);
        
        UIImage *image = [UIImage imageNamed:@"back"];
        image = [image imageWithColor:[UIColor blackColor]];
        [back setImage:image forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:back];
    }
    return _topView;
}
-(void)backAction
{
    [self.delegate backAction];
}
- (BaseScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [BaseScrollView scrollViewWithFrame:CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == self.contentScrollView) {
//        if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > (self.sliderViewControllers.count-1)*SCREEN_WIDTH) {
//            scrollView.panGestureRecognizer.enabled = NO;
//        } else {
//            scrollView.panGestureRecognizer.enabled = YES;
//        }
//    }
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.contentScrollView.height = self.view.height - TopViewHeight;
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.height)];
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
