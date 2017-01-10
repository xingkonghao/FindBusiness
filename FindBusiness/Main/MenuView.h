//
//  MenuView.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/9.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeHandler)(NSInteger index);
@interface MenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseImage;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (copy, nonatomic) completeHandler handler;
@property (nonatomic,strong)NSDictionary *params;
- (IBAction)changeAction:(id)sender;

- (IBAction)uploadAction:(id)sender;
- (IBAction)choosenAction:(id)sender;
- (IBAction)scanAction:(id)sender;

+(MenuView*)initWith:(id)owner CompleteHandler:(void(^)(NSInteger index))completeHandler;
@end
