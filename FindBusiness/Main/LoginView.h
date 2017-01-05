//
//  LoginView.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/3.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *passHidden;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UILabel *passHiddenLab;
- (IBAction)registAction:(id)sender;
- (IBAction)forgetAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)passHiddenAction:(id)sender;
-(void)compeleteHandler:(void(^)(NSString*userName,NSString*um))handler;
@end
