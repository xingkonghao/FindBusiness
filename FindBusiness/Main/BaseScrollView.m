//
//  BaseScrollView.m
//  lixy
//
//  Created by  星空浩818 on 14/10/16.
//  Copyright (c) 2014年  星空浩818. All rights reserved.
//

#import "BaseScrollView.h"

@interface BaseScrollView ()

@end

@implementation BaseScrollView

+ (instancetype)scrollViewWithFrame:(CGRect)frame
{
    BaseScrollView *sv = [[BaseScrollView alloc] initWithFrame:frame];
    return sv;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCommonUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommonUI];
    }
    return self;
}

//设置公共属性
- (void)initCommonUI
{
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.backgroundColor = [UIColor clearColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
