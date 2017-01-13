//
//  ExampleView.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/11.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "ExampleView.h"

@implementation ExampleView

+(ExampleView*)loadNibWithFrme:(CGRect)frame action:(void(^)(BOOL isgoOn))action;
{
    ExampleView *view = [[NSBundle mainBundle]loadNibNamed:@"View" owner:self options:nil].lastObject;
    view.frame = frame;
    [view addSubview:view.scrollView];
    view.block = action;
   return view;
}
-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-self.goOn.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width*7, self.frame.size.height-self.goOn.frame.size.height);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        NSArray *arr = @[@"demo_dmjzb",@"demo_zyjz",@"demo_cjjsb",@"demo_ccjch",@"demo_xfjab",@"demo_dqdj",@"demo_qtzp"];
        NSArray *titleArr = @[@"大门及周边",@"主要建筑",@"车间及设备",@"仓储及存货",@"消防及安全",@"电气灯具",@"其他照片"];
        int i = 0;
        for (NSString * name in arr) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*i,0, self.frame.size.width, _scrollView.frame.size.height)];
            imageView.image = [UIImage imageNamed:name];
            [_scrollView addSubview:imageView];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width/2.0-100, 20,200, 30)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = [NSString stringWithFormat:@"%@示例",titleArr[i]];
            lable.textColor = [UIColor redColor];
            lable.font = [UIFont systemFontOfSize:20];
            [imageView addSubview:lable];
            i++;
        }
     
    }
    return _scrollView;
}
- (IBAction)goOnaction:(id)sender {
    self.block(YES);
}

- (IBAction)giveUpAction:(id)sender {
    self.block(NO);

}
@end
