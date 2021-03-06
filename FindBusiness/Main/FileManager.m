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
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[_userDefaults objectForKey:@"userInfo"]];
    NSString *um = userInfo[@"UM"];
    
    NSMutableArray *uploadArr = [NSMutableArray array];
    if (um) {
        uploadArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:um]];
        if (uploadArr==nil) {
            uploadArr = [NSMutableArray array];
        }
        int index = 0;
        NSMutableArray *tempArr = [uploadArr mutableCopy];
        
        if (item[@"fileId"]) {//修改
            for (NSDictionary *dict in tempArr) {
                
                if ([dict[@"fileId"] integerValue]==[item[@"fileId"] integerValue]) {
                    [uploadArr replaceObjectAtIndex:index withObject:item];
                    break;
                }
                index ++;
            }
        }else//新添
        {
            [item setValue:[NSNumber numberWithLong:uploadArr.count+1] forKey:@"fileId"];
            //添加图片限制
            [item setValue:@"60" forKey:@"limitNum"];
            [uploadArr addObject:item];
        }
        
        [_userDefaults setObject:uploadArr forKey:um];
        [_userDefaults synchronize];
        
    }
}
+(void)deleteItem:(NSDictionary*)item;
{
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[_userDefaults objectForKey:@"userInfo"]];
    NSString *um = userInfo[@"UM"];
    
    NSMutableArray *uploadArr = [NSMutableArray array];
    
    if (um) {
        uploadArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:um]];
        if (uploadArr==nil) {
            uploadArr = [NSMutableArray array];
        }
        
        int index = 0;
        BOOL alreadyDelete = NO;
        NSMutableArray *tempArr = [uploadArr mutableCopy];
        for (NSDictionary *dict in tempArr) {
            //根据id删除item
            if ([dict[@"fileId"] integerValue]==[item[@"fileId"] integerValue]) {
                [uploadArr removeObjectAtIndex:index];
                alreadyDelete = YES;
                continue;
            }
            if (alreadyDelete) {//将删除的item后面的item进位
                NSInteger fileId = [dict[@"fileId"] integerValue];
                fileId --;
                [dict setValue:[NSNumber numberWithLong:fileId] forKey:@"fileId"];
                [uploadArr replaceObjectAtIndex:index-1 withObject:dict];
            }
            index ++;
        }
        if (uploadArr.count==0) {
            [_userDefaults removeObjectForKey:um];
        }else
        {
            [_userDefaults setValue:uploadArr forKey:um];
        }
        [_userDefaults synchronize];
        
    }
    
    [FileManager deleteFile:item];
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
#pragma mark 压缩
+(NSData*)zipData:(NSDictionary*)item object:(id)obj;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *um = [FileManager getUserUM];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    NSString *cachUserPath = [CACHES_DIRECTORY stringByAppendingPathComponent:um];
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:cachUserPath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:cachUserPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",item[@"name"]]];
    
    NSString *zipFilePath = [cachUserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",item[@"name"]]];
    
    
    NSMutableArray *categorypaths = [[fileManager contentsOfDirectoryAtPath:businessDirectory error:nil] mutableCopy];
    NSString *CategoryZipFilesPath = [cachUserPath stringByAppendingPathComponent:@"CategoryZipFilePath"];
    
    
    
    if (![fileManager fileExistsAtPath:CategoryZipFilesPath]) {
        [fileManager createDirectoryAtPath:CategoryZipFilesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    ZipArchive *zip = [[ZipArchive alloc]init];
    zip.delegate = obj;
    
    if (categorypaths.count==1) {
        NSString *zhanwei  = @"该txt文件是用来占位用的，否则当只有一个文件的时候会直接压缩子文件夹";
        [zhanwei writeToFile:[CategoryZipFilesPath stringByAppendingPathComponent:@"temp.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    //先压缩分类
    for (NSString *category in categorypaths) {
        if ([category isEqualToString:@".DS_Store"]) {
            continue;
        }
        NSString *CategoryZipFilePath = [CategoryZipFilesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",category]];
        
        [zip CreateZipFile2:CategoryZipFilePath];
        
        NSString *categoryPath = [businessDirectory stringByAppendingPathComponent:category];
        NSArray *imgPaths = [fileManager contentsOfDirectoryAtPath:categoryPath error:nil];
        if (imgPaths.count==1) {
            NSString *zhanwei  = @"该txt文件是用来占位用的，否则当只有一个文件的时候会直接压缩子文件夹";
            [zhanwei writeToFile:[categoryPath stringByAppendingPathComponent:@"temp.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            imgPaths = [fileManager contentsOfDirectoryAtPath:categoryPath error:nil];
            
        }
        
        for (NSString *imgName in imgPaths) {
            if ([imgName isEqualToString:@".DS_Store"]) {
                continue;
            }
            NSString *imagePath = [categoryPath stringByAppendingPathComponent:imgName];
            [zip addFileToZip:imagePath newname:imgName];
        }
        BOOL succsess = [zip CloseZipFile2];
        if (succsess) {
            NSLog(@"%@ 压缩成功",category);
        }
        
    }
    //再把压缩过的分类压缩成一个整体
    [zip CreateZipFile2:zipFilePath];
    
    NSArray *categorysZipPaths = [fileManager contentsOfDirectoryAtPath:CategoryZipFilesPath error:nil];
    for (NSString *category in categorysZipPaths) {
        NSString *tempzip = [CategoryZipFilesPath stringByAppendingPathComponent:category];
        [zip addFileToZip:tempzip newname:category];
    }
    
    BOOL succsess = [zip CloseZipFile2];
    NSLog(@"zipped %d",succsess);
    NSData *resultData = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [DFYGProgressHUD showProgressHUDWithMode:ProgressHUDModeOnlyText withText:succsess?@"文件压缩成功":@"文件压缩失败" afterDelay:1 isTouched:YES inView:nil];
    });
    
    if (succsess) {
        resultData = [NSData dataWithContentsOfFile:zipFilePath];
        //        [self unzip:item];
        
    }
    return resultData;
}
+(void)unzip:(NSDictionary*)item
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL ret ;
    BOOL isDirectory;
    
    ZipArchive *zip = [[ZipArchive alloc]init];
    NSString *userDirectory = [CACHES_DIRECTORY stringByAppendingPathComponent:[FileManager getUserUM]];
    ret = [manager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (ret==NO) {
        NSLog(@"路径创建失败");
    }
    NSString *path2 = [userDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",item[@"name"]]];
    ret = [manager fileExistsAtPath:path2 isDirectory:&isDirectory];
    if (ret==NO) {
        NSLog(@"压缩文件不存在");
    }
    NSData *data = [[NSData alloc]initWithContentsOfFile:path2];
    NSLog(@"%@",data);
    ret = [zip UnzipFileTo:path2 overWrite:YES];
    if (ret==NO) {
        NSLog(@"解压缩失败");
    }
    [zip UnzipCloseFile];
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:item[@"name"]];
    
    
    ret =  [manager fileExistsAtPath:businessDirectory isDirectory:&isDirectory];
    if (ret==NO) {
        NSLog(@"商机文件夹不存在");
    }
    NSArray *paths = [manager contentsOfDirectoryAtPath:businessDirectory error:nil];
    NSLog(@"%@",paths);
    //    ret = [manager fileExistsAtPath:businessDirectory isDirectory:&isDirectory];
    //    if (ret==NO) {
    //        NSLog(@"商机文件夹不存在");
    //    }
    
}
+(NSString*)getUserUM;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    return um;
}
#pragma NSFileManager
+(void)writeData:(NSData*)data toDiskWithBusinessName:(NSString*)businessName category:(NSString*)category;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:businessName];
    if (![fileManager fileExistsAtPath:businessDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:businessDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *categoryDirectory = [businessDirectory stringByAppendingPathComponent:category];
    if (![fileManager fileExistsAtPath:categoryDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:categoryDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *filePaths = [fileManager contentsOfDirectoryAtPath:categoryDirectory error:nil];
    if (!filePaths) {
        filePaths =[NSArray array];
    }
    NSString *filePath = [categoryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png",filePaths.count + 1]];
    NSLog(@"%@",filePath);
    [data writeToFile:filePath atomically:YES];
}
+(void)deleteFile:(NSDictionary*)item;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    //移除沙盒商机下的照片
    BOOL isDirectory;
    if ([fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory]) {
        NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:item[@"name"]];
        if ([fileManager fileExistsAtPath:businessDirectory isDirectory:&isDirectory]) {
            [fileManager removeItemAtPath:businessDirectory error:nil];
        }
    }
    
    //移除缓存的zip文件
    NSString *cachUserPath = [CACHES_DIRECTORY stringByAppendingPathComponent:um];
    if([fileManager fileExistsAtPath:cachUserPath isDirectory:&isDirectory])
    {    NSString *path2 = [cachUserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",item[@"name"]]];
        
        if ([fileManager fileExistsAtPath:path2 isDirectory:&isDirectory]) {
            [fileManager removeItemAtPath:path2 error:nil];
        }
    }
    
}
+(BOOL)deleteImage:(NSInteger)index category:(NSString*)category item:(NSDictionary*)item;
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    //移除沙盒商机下的照片
    BOOL isDirectory;
    if ([fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory]) {
        NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:item[@"name"]];
        
        if ([fileManager fileExistsAtPath:businessDirectory isDirectory:&isDirectory]) {
            NSString *categoryPath = [businessDirectory stringByAppendingPathComponent:category];
            if ([fileManager fileExistsAtPath:categoryPath isDirectory:&isDirectory]) {
                NSString *filePath = [categoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png",index+1]];
                if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
                    [fileManager removeItemAtPath:filePath error:nil];
                    NSArray *categoryPaths = [fileManager contentsOfDirectoryAtPath:categoryPath error:nil];
                    if (categoryPaths.count==0) {
                        [fileManager removeItemAtPath:categoryPath error:nil];
                    }
                    success = YES;
                }
            }
        }
    }
    return success;
}
+(NSArray*)getCategotysUnderBusiness:(NSString*)businessName
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:userDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:businessName];
    if (![fileManager fileExistsAtPath:businessDirectory isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:businessDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *categorys = [fileManager contentsOfDirectoryAtPath:businessDirectory error:nil];
    
    return categorys;
}
+(NSArray*)getitemUnderCategory:(NSString*)category businessName:(NSString*)businessName;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:businessName];
    
    
    NSString *categoryDirectory = [businessDirectory stringByAppendingPathComponent:category];
    
    
    NSArray *items = [fileManager contentsOfDirectoryAtPath:categoryDirectory error:nil];
    
    return items;
    
}
+(NSString*)getdataPath:(NSString*)dataName category:(NSString*)category businessName:(NSString*)businessName;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    
    NSString *businessDirectory = [userDirectory stringByAppendingPathComponent:businessName];
    
    
    NSString *categoryDirectory = [businessDirectory stringByAppendingPathComponent:category];
    
    NSString *filePath = [categoryDirectory stringByAppendingPathComponent:dataName];
    
    return filePath;
}
+(NSString*)getDataName:(NSDictionary*)item;
{
    NSString*name;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [_userDefaults objectForKey:@"userInfo"];
    NSString *um = userInfo[@"UM"];
    NSString *cachUserPath = [CACHES_DIRECTORY stringByAppendingPathComponent:um];
    
    NSString *userDirectory = [documentsDirectory stringByAppendingPathComponent:um];
    NSString *filePath = [cachUserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",item[@"name"]]];
    
    BOOL exist = NO;
    exist = [fileManager fileExistsAtPath:filePath];
    name = exist?[filePath lastPathComponent]:@"";
    return name;
}
@end
