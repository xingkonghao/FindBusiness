//
//  CreatBusinessVC.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/9.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "CreatBusinessVC.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "FileManager.h"


@interface CreatBusinessVC ()<CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    CLLocationManager *_locationManager;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    BMKGeoCodeSearch *_search;
    BMKReverseGeoCodeOption *_opt;
    BMKLocationService *_locService;
    NSString *netType;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *locaton;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *creatBtn;
@property (weak, nonatomic) IBOutlet UITextField *dongshu;
@property (weak, nonatomic) IBOutlet UITextField *mianji;
@property (nonatomic,strong)NSMutableDictionary *params;
@property (nonatomic,strong) NSString *longtitude;
@property (nonatomic,strong)NSString *atitude;
@end

@implementation CreatBusinessVC
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _params = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    return self;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.params = [NSMutableDictionary dictionary];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatNavi];
    self.title = @"创建商机";
    arr1 = [NSMutableArray array];
    arr2 =[NSMutableArray array];
    
    _btn1.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,120);
    _btn3.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,120);
    
    _btn2.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,70);
    _btn4.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,60);
    _btn5.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,60);
    _btn6.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5,60);

    
    [self locationSet];
    [self loadBeforeData];
}
-(void)loadBeforeData
{
    if (_params.allKeys.count>0) {
        self.name.text = _params[@"name"];
        self.longtitude = _params[@"jing"];
        self.atitude = _params[@"wei"];
        NSString *location = [NSString stringWithFormat:@"经度：%@|纬度：%@",_params[@"jing"],_params[@"wei"]];
        self.locaton.text = STR_IS_NIL(_params[@"local"])?location:_params[@"local"];
        self.mianji.text = _params[@"mianji"];
        self.dongshu.text = _params[@"dongshu"];
        arr1 = [NSMutableArray arrayWithArray:[_params[@"jiegou"] componentsSeparatedByString:@"|"]];
        arr2 = [NSMutableArray arrayWithArray:[_params[@"xiaofang"] componentsSeparatedByString:@"|"]];
        for (NSString *txt in arr1) {
            if ([txt isEqualToString:@"钢或砖混结构"]) {
                _btn1.selected = YES;
            }else if ([txt isEqualToString:@"轻钢结构"])
            {
                _btn2.selected = YES;
            }else if ([txt isEqualToString:@"砖墙钢顶或重钢"])
            {
                _btn3.selected = YES;
            }else
            {
                _btn4.selected = YES;
            }
        }
        for (NSString *txt in arr2) {
            if ([txt isEqualToString:@"消防栓"]) {
                _btn5.selected = YES;
            }else if ([txt isEqualToString:@"灭火器"])
            {
                _btn6.selected = YES;
            }
        }

    }
}
- (IBAction)locationAction:(id)sender {
    [self loactionAction];
}

#pragma mark 定位
- (void)locationSet
{
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _search = [[BMKGeoCodeSearch alloc]init];
    _search.delegate = self;
    _opt = [[BMKReverseGeoCodeOption alloc]init];
    
}
-(void)creatNavi
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20, 45,44);
    
    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithColor:[UIColor blackColor]];
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:kNetworkType style:UIBarButtonItemStylePlain target:self action:@selector(noAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)noAction
{
    
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    switch (sender.tag) {
        case 100:
            
            if (sender.selected) {
                [arr1 addObject:@"钢或砖混结构"];
            }else
            {
                if ([arr1 containsObject:@"钢或砖混结构"]) {
                    [arr1 removeObject:@"钢或砖混结构"];
                }
            }
            break;
        case 101:
            if (sender.selected) {
                [arr1 addObject:@"轻钢结构"];
            }else
            {
                if ([arr1 containsObject:@"轻钢结构"]) {
                    [arr1 removeObject:@"轻钢结构"];
                }
            }

            break;
        case 102:
            if (sender.selected) {
                [arr1 addObject:@"砖墙钢顶或重钢"];
            }else
            {
                if ([arr1 containsObject:@"砖墙钢顶或重钢"]) {
                    [arr1 removeObject:@"砖墙钢顶或重钢"];
                }
            }

            break;
        case 103:
            if (sender.selected) {
                [arr1 addObject:@"其他"];
            }else
            {
                if ([arr1 containsObject:@"其他"]) {
                    [arr1 removeObject:@"其他"];
                }
            }

            break;
        case 104:
            if (sender.selected) {
                [arr2 addObject:@"消防栓"];
            }else
            {
                if ([arr2 containsObject:@"消防栓"]) {
                    [arr2 removeObject:@"消防栓"];
                }
            }

            break;
        case 105:
            if (sender.selected) {
                [arr2 addObject:@"灭火器"];
            }else
            {
                if ([arr2 containsObject:@"灭火器"]) {
                    [arr2 removeObject:@"灭火器"];
                }
            }

            break;
        default:
            break;
    }
}
- (IBAction)creatAction:(id)sender {
    if (self.name.text.length<=0) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"请填写商机名称" afterDelay:1.5 isTouched:YES inView:nil];
        return;
    }
    if (self.locaton.text.length==0) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"请填写定位信息" afterDelay:1.5 isTouched:YES inView:nil];
        return;
    }
    if (self.dongshu.text.length==0) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"请填写房屋栋数" afterDelay:1.5 isTouched:YES inView:nil];
        return;
    }
    if (self.mianji.text.length ==0) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"请填写最大面积" afterDelay:1.5 isTouched:YES inView:nil];
        return;
    }
    NSUserDefaults *userManager = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userManager objectForKey:@"userInfo"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];

    [self.params setObject:userInfo[@"username"] forKey:@"user"];
    [self.params setObject:userInfo[@"UM"] forKey:@"code"];

    [self.params setObject:self.locaton.text forKey:@"local"];
    [self.params setObject:self.name.text forKey:@"name"];
    [self.params setObject:self.longtitude forKey:@"jing"];
    [self.params setObject:self.atitude forKey:@"wei"];
    [self.params setObject:dateStr forKey:@"date"];
    if (arr1.count>0) {
        [self.params setObject:[self getJIGOU:arr1] forKey:@"jiegou"];
    }
    [self.params setObject:self.dongshu.text forKey:@"dongshu"];
    [self.params setObject:self.mianji.text forKey:@"mianji"];
    if (arr2.count>0) {
        [self.params setObject:[self getJIGOU:arr2] forKey:@"xiaofang"];
    }
    [self.params setObject:@"未上传" forKey:@"state"];
    [FileManager addItem:self.params];
        
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BusinessReload" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)getJIGOU:(NSArray*)arr
{
    NSString *retunStr = nil;
    for (NSString * str in arr) {
        if (retunStr.length == 0) {
            retunStr = str;
        }else
        {
            retunStr = [retunStr stringByAppendingString:[NSString stringWithFormat:@"|%@",str]];
        }
    }
    return retunStr;
}
-(void)loactionAction
{
    [_locService startUserLocationService];
}
#pragma textfileDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 百度地图delegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    [self setBirdge:userLocation];

    
}
- (void)setBirdge:(BMKUserLocation*)userlocation
{
//        NSLog(@"%@",userlocation.location);
    self.longtitude = [NSString stringWithFormat:@"%f",userlocation.location.coordinate.longitude];
    self.atitude = [NSString stringWithFormat:@"%f",userlocation.location.coordinate.latitude];
    self.locaton.text = [NSString stringWithFormat:@"经度%@，纬度%@",self.longtitude,self.atitude];
    CLLocationCoordinate2D pt = userlocation.location.coordinate;
    _opt.reverseGeoPoint = pt;
    BOOL flag = [_search reverseGeoCode:_opt];
    if (flag) {
        NSLog(@"检索成功");
    }else
    {
        NSLog(@"检索失败");
    }
    
    
}

-(void)didFailToLocateUserWithError:(NSError *)error
{
    
//    NSLog(@"%@",error.description);
    if (error.code ==1)
    {
        
    }
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"%@",userLocation.heading);
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR ) {
        
        self.locaton.text = result.address;
        
    }else
    {
        
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_name resignFirstResponder];
    [_dongshu resignFirstResponder];
    [_mianji resignFirstResponder];
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
