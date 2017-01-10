//
//  FileManager.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
{
}
@end

@implementation FileManager
-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

+(void)addItem:(NSDictionary*)item
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    
    NSMutableArray *uploadArr = [NSMutableArray array];
    if (um) {
        uploadArr = [_userDefaults objectForKey:um];
        if (uploadArr==nil) {
            uploadArr = [NSMutableArray array];
        }
    }
    [uploadArr addObject:item];
    
    [_userDefaults setObject:uploadArr forKey:um];
    [_userDefaults synchronize];
}
+(void)addLimitNum:(NSDictionary*)item;
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    
    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
    if (um) {
        uploadDic = [_userDefaults objectForKey:um];
        if (uploadDic==nil) {
            uploadDic = [NSMutableDictionary dictionary];
        }
    }
    [uploadDic setObject:item forKey:[NSString stringWithFormat:@"%@limit",um]];
    [_userDefaults setObject:uploadDic forKey:um];
    [_userDefaults synchronize];

}
+(NSArray*)getItems;
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    
    NSArray *uploadArr = [NSArray array];
    if (um) {
        uploadArr = [_userDefaults objectForKey:um];
        if (uploadArr==nil) {
            uploadArr = [NSArray array];
        }
    }
    return uploadArr;

}
+(NSDictionary*)getLimitData;
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    
    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
    if (um) {
        uploadDic = [_userDefaults objectForKey:um];
        if (uploadDic==nil) {
            uploadDic = [NSMutableDictionary dictionary];
        }
    }
    return uploadDic;
}
@end
