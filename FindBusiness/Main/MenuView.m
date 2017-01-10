//
//  MenuView.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/9.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView
- (IBAction)changeAction:(id)sender {
    self.handler(2);
    
}

- (IBAction)uploadAction:(id)sender {
    self.handler(1);

}

- (IBAction)choosenAction:(id)sender {
    self.handler(3);

}

- (IBAction)scanAction:(id)sender {
    self.handler(4);

}

+(MenuView*)initWith:(id)owner CompleteHandler:(void(^)(NSInteger index))completeHandler;
{
    MenuView *menu = [[[NSBundle mainBundle]loadNibNamed:@"MenuView" owner:owner options:nil] lastObject];
    menu.frame = kScreenBounds;
    menu.handler = completeHandler;
    
    return menu;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        self.hidden = YES;
    }
}
@end
