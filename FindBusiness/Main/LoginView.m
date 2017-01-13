//
//  LoginView.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/3.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "LoginView.h"

typedef void(^handler)(NSString*userName,NSString*um);

@interface LoginView ()<UITextFieldDelegate>
{
    CGFloat transSpace;
}
@property (nonatomic,copy)handler handler;
@end
@implementation LoginView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    self.userName.delegate = self;
    self.password.delegate = self;
    [self.password setSecureTextEntry:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)registAction:(id)sender {
}

- (IBAction)forgetAction:(id)sender {
}

- (IBAction)loginAction:(id)sender {
    [self request_login];
}

- (IBAction)passHiddenAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    _passHiddenLab.text = sender.selected==YES?@"显示密码":@"隐藏密码";
    [_password setSecureTextEntry:!sender.selected];
}
-(void)compeleteHandler:(void(^)(NSString*userName,NSString*um))handler;
{
    self.handler = handler;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        self.handler(nil,nil);

    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardShow:(NSNotification*)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    transSpace = CGRectGetMaxY(self.backView.frame) - CGRectGetMinY(keyboardRect);
    if (transSpace>0) {
        self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y-transSpace,self.backView.frame.size.width, self.backView.frame.size.height);
    }
    
}
-(void)keyboardHidden
{
    if (transSpace>0) {
        self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y+transSpace,self.backView.frame.size.width, self.backView.frame.size.height);
    }
}
-(void)request_login
{
    
    if (self.userName.text.length>0&&self.password.text.length>0) {
        NSString *url = [NSString stringWithFormat:@"%@user=%@&pass=%@",loginUrl,self.userName.text,self.password.text];
       
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeProgress withText:@"加载中..." isTouched:YES inView:nil];
        [[NetWorkManager sharedInstance]requestDataForGETWithURL:url parameters:nil Controller:nil success:^(id responseObject) {
            [DFYGProgressHUD hideProgressHUDAfterDelay:0];
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",string);
            if (string) {
                NSArray *strs = [string componentsSeparatedByString:@"_"];
                if ([strs.firstObject isEqualToString:@"true"]) {
                    self.handler(self.userName.text,strs.lastObject);
                    [self saveUserInfoWithUM:strs.lastObject];
                    [[ZFDownloadManager sharedDownloadManager] loadData];

                }else
                {
                    [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:string afterDelay:1 isTouched:YES inView:nil];

                }
            }
//            self.handler(@"18500610732");

        } failure:^(NSError *error) {
            
        }];
    }else
    {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"用户名或密码为空" afterDelay:1.5 isTouched:YES inView:nil];
    }
}
-(void)request_register
{

    
}
-(void)saveUserInfoWithUM:(NSString*)um
{
    NSUserDefaults *userManager = [NSUserDefaults standardUserDefaults];
    [userManager setObject:@{@"username":self.userName.text,@"UM":um} forKey:@"userInfo"];
    [userManager synchronize];
}
@end
