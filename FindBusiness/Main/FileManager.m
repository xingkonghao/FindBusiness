//
//  FileManager.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
@property (nonatomic,strong)NSFileManager *fileManager;
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,strong)NSMutableArray *plistData;

@end

@implementation FileManager
-(instancetype)init
{
    if (self = [super init]) {
        _completePath = [NSString stringWithFormat:@"%@/%@",[self getDownLoadPath],@"complete.plist"];
        _unCompletePath = [NSString stringWithFormat:@"%@/%@",[self getDownLoadPath],@"uncomplete.plist"];
        _downloadPath = [self getDownLoadPath];
    }
    return self;
}
-(void)addNewFile:(NSDictionary*)item filePath:(NSString*)filePath;
{
 
    [self creatFilePath:filePath];
    
    [self.plistData addObject:item];

    [self.plistData writeToFile:_filePath atomically:YES];
}
-(NSFileManager*)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return  _fileManager;
}

-(NSString*)creatFilePath:(NSString*)filePath
{
    if (![self.fileManager fileExistsAtPath:filePath]) {
        NSLog(@"第一次创建");
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"Download"];
        NSError *error = nil;
        [_fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件夹失败");
            return @"";
        }
        [_fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    self.filePath = filePath;
    NSLog(@"%@",_filePath);
    return filePath;
}
-(void)getPlist
{
    self.plistData = [NSMutableArray arrayWithContentsOfFile:_filePath];
}
-(NSMutableArray*)plistData
{
    if (!_plistData) {
        _plistData = [NSMutableArray arrayWithContentsOfFile:_filePath];
        if (_plistData  == nil) {
            _plistData = [NSMutableArray array];
        }
    }
    return _plistData;
}
-(NSString*)getFilePath:(NSString *)name
{
    NSString *docPath = NSHomeDirectory();
    
    NSString*filePath = [NSString stringWithFormat:@"%@/Documents/Download/%@",docPath,[NSString md5:name]];

  return filePath;
}
-(NSData*)getDataWithFilePath:(NSString *)filePath
{
    return [NSData dataWithContentsOfFile:filePath];
}
-(NSString*)getDownLoadPath
{
    return [NSString stringWithFormat:@"%@/Documents/Download",NSHomeDirectory()];

}

//-(NSMutableArray*)getPlistWithFilePath:(NSString *)filePath
//{
//    NSMutableArray *dataArr = [NSMutableArray array];
//    NSArray *tempArr = [NSArray arrayWithContentsOfFile:filePath];
//    for (NSDictionary *dic in tempArr) {
//        DownloadModel *model = [[DownloadModel alloc]initWithData:dic];
//        [dataArr addObject:model];
//    }
//    return dataArr;
//}
-(NSMutableArray*)getDictWithFilePath:(NSString *)filePath;
{
    return [NSMutableArray arrayWithContentsOfFile:filePath];
}

-(void)writeResumeDataToDask:(NSData*)data filePath:(NSString *)filePath
{
    NSURL *path = [NSURL URLWithString:filePath];
    [data writeToURL:path atomically:YES];
}
-(void)removeData:(NSString*)filePath
{

    [self.fileManager removeItemAtPath:filePath error:nil];
}
-(void)removeInfo:(NSInteger)index path:(NSString*)filePath;
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (dataArr.count>=index) {
        NSDictionary *dic = dataArr[index];
        NSString *dataPath = [NSString stringWithFormat:@"%@/%@",[self getDownLoadPath],[NSString md5:dic[@"url"]]];
        [self removeData:dataPath];
        [dataArr removeObjectAtIndex:index];
    }
}
@end
