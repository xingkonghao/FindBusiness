//
//  BaseSliderController.h
//  lixy
//
//  Created by  星空浩818 on 14/10/28.
//  Copyright (c) 2014年  星空浩818. All rights reserved.
//

#import "BaseScrollView.h"

@protocol SliderDelegate <NSObject>

-(void)backAction;

@end

@interface BaseSliderController : UIViewController

@property (nonatomic,weak)id <SliderDelegate> delegate;
@property (nonatomic, strong) NSArray *topTitles;
@property (nonatomic) CGFloat topBtnWidth;
@property (nonatomic) CGFloat sliderWidth;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *sliderViewControllers;
@property (nonatomic, strong, readonly) BaseScrollView *contentScrollView;

@end
