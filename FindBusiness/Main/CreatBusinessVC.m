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


@interface CreatBusinessVC ()<CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationManager *_locationManager;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    BMKGeoCodeSearch *_search;
    BMKReverseGeoCodeOption *_opt;
    BMKLocationService *_locService;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatNavi];
    self.title = @"创建商机";
    self.params = [NSMutableDictionary dictionary];
    arr1 = [NSMutableArray array];
    arr2 =[NSMutableArray array];
    [self locationSet];
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
    image = [image imageWithColor:[UIColor blackColor]];
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    

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
                [arr1 addObject:@"其他结构"];
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
    if (self.name.text.length==0||self.locaton.text.length==0||self.dongshu.text==0||self.mianji.text==0) {
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:@"有必填选项未填写" afterDelay:1.5 isTouched:YES inView:nil];
        return;
    }
    NSUserDefaults *userManager = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userManager objectForKey:@"userInfo"];
    NSString *dateStr = [NSDate dateToString:[NSDate date]];

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
    
    NSLog(@"%@",error.description);
    if (error.code ==1)
    {
        
    }
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"%@",userLocation.heading);
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
