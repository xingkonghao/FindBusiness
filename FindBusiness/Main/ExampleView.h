//
//  ExampleView.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/11.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^action)(BOOL isgoOn);

@interface ExampleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *giveUp;
@property (weak, nonatomic) IBOutlet UIButton *goOn;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (copy, nonatomic) action block;
- (IBAction)goOnaction:(id)sender;
- (IBAction)giveUpAction:(id)sender;
+(ExampleView*)loadNibWithFrme:(CGRect)frame action:(void(^)(BOOL isgoOn))action;

@end
