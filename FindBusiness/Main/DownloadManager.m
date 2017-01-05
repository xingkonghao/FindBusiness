//
//  DownloadManager.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "DownloadManager.h"
#import "FileManager.h"
@interface DownloadManager()
@property (nonatomic,strong)NSMutableArray *taskArray;
@end

@implementation DownloadManager
static DownloadManager *shareManager =nil;
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[DownloadManager alloc]init];
    });
    return shareManager;
}
-(instancetype)init
{
    if (self = [super init]) {
        FileManager *fileManager = [[FileManager alloc]init];
        NSArray *infoArr = [fileManager getDictWithFilePath:fileManager.unCompletePath];
        
        for (int i = 0; i<infoArr.count; i++) {
            [self prestrainTasks:infoArr[i] index:i];
        }
    }
    return self;
}
-(NSMutableArray*)taskArray
{
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}
-(void)addNewDownloadTask:(NSString*)url
{
    NSDictionary*params = [self addNewFileToDask:url];
    
    NSURLSessionDownloadTask *task =  [self downLoadFile:params];
    
    [task resume];

}

//提前加载下载的task但不resume 每次启动应用加载一次
-(void)prestrainTasks:(NSDictionary*)model index:(NSInteger)index
{
//    DownloadModel *model = [[DownloadModel alloc]initWithData:dict];
    [self downLoadFile:model];
}
-(NSDictionary*)addNewFileToDask:(NSString*)name
{
    NSDictionary *params = @{@"url":name,@"totalUnitCount":@"1",@"completedUnitCount":@"0"};
    FileManager *fileManager = [[FileManager alloc]init];
    [fileManager addNewFile:params filePath:fileManager.unCompletePath];
    return params;
}
-(void)updatePlistInfo:(NSString*)filePath name:(NSDictionary*)dict
{
    FileManager *manager = [self getFilemanager];
    if (![filePath containsString:@"uncomplete"]) {
        [manager addNewFile:dict filePath:filePath];
    }

    NSMutableArray *infos = [manager getDictWithFilePath:filePath];
    NSInteger count = infos.count;
    for (int i = 0; i<count; i++) {
        NSDictionary *params = infos[i];
        if ([params[@"url"] isEqualToString:dict[@"url"]]) {
            [infos replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
    [infos writeToFile:filePath atomically:YES];
}
-(void)removePlistInfo:(NSString*)filePath name:(NSDictionary*)dict
{
    FileManager *manager = [self getFilemanager];
    NSMutableArray *infos = [manager getDictWithFilePath:filePath];
    NSInteger count = infos.count;
    for (int i = 0; i<count; i++) {
        NSDictionary *params = infos[i];
        if ([params[@"url"] isEqualToString:dict[@"url"]]) {
          
            [infos removeObject:params];
            if ([dict[@"totalUnitCount"] isEqualToString:dict[@"completedUnitCount"]]) {
                [self updatePlistInfo:manager.completePath  name:dict];
            }
            break;
        }
    }
    [infos writeToFile:filePath atomically:YES];
}

#pragma mark 下载请求
-(NSURLSessionDownloadTask*)downLoadFile:(NSDictionary*)dict
{
    NSURLSessionDownloadTask *task = [[NetWorkManager sharedInstance]downloadFileWithUrl:dict taskIndex:1 progress:^(NSProgress *downloadProgress,NSDictionary*model) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:model];
        [dict setValue:[NSString stringWithFormat:@"%lld",downloadProgress.totalUnitCount] forKeyPath:@"totalUnitCount"];
        [dict setValue:[NSString stringWithFormat:@"%lld",downloadProgress.completedUnitCount] forKeyPath:@"completedUnitCount"];
        FileManager *manager = [self getFilemanager];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self updatePlistInfo:[manager unCompletePath] name:dict];
//            if (downloadProgress.completedUnitCount == downloadProgress.totalUnitCount) {
//                [self updatePlistInfo:manager.completePath name:dict];
//            }
//        });
        [self updatePlistInfo:[manager unCompletePath] name:dict];
        if (downloadProgress.completedUnitCount == downloadProgress.totalUnitCount) {
            [self updatePlistInfo:manager.completePath name:dict];
            [self removePlistInfo:manager.unCompletePath name:model];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"CompleteReload" object:nil];
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"unCompleteReload" object:nil];
        self.progressBlock(downloadProgress,model);
    }
                                      
    completeHandler:^(BOOL isSuccess,NSDictionary*model) {
       
        if (isSuccess) {
//            FileManager *manager = [self getFilemanager];
//            [self removePlistInfo:manager.unCompletePath name:model];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"unCompleteReload" object:nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"CompleteReload" object:nil];

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC),dispatch_get_global_queue(1002, 0), ^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"CompleteReload" object:nil];
//            });

        }
    }];
    [self addTask:task];

    return task;
}
-(void)getProgress:(progressBlock)progressBlock
{
    self.progressBlock = progressBlock;
}
-(void)completeHandler:(completeHandler)block
{
    self.completeHandler = block;
}
-(void)addTask:(NSURLSessionDownloadTask*)task
{
    if( ![self.taskArray containsObject:task])
    {
        [self.taskArray addObject:task];
    }

}
-(void)removetask:(NSURLSessionDownloadTask*)task
{
    if( [self.taskArray containsObject:task])
    {
        [self.taskArray removeObject:task];
        
    }

}
-(void)taskPause:(NSURLSessionDownloadTask*)task
{
    [task suspend];
}
-(void)taskResume:(NSURLSessionDownloadTask*)task
{
    [task resume];
}
-(void)removeDownloadTask:(NSInteger)index
{
    if (self.taskArray.count>=index) {
        NSURLSessionDownloadTask *task = self.taskArray[index];
        if (task) {
            [self removetask:task];
            [self moveCompleteInfoToPlist:index];
        }
    }
}
-(void)pasueDownloadTask:(NSInteger)index
{
    if (self.taskArray.count>=index) {
        NSURLSessionDownloadTask *task = self.taskArray[index];
        if (task) {
            [self taskPause:task];
           
        }
    }
}
-(void)reseumeDownloadTask:(NSInteger)index
{
    if (self.taskArray.count>=index) {
        NSURLSessionDownloadTask *task = self.taskArray[index];
        if (task) {
            [self taskResume:task];
        }
    }
}
-(void)moveCompleteInfoToPlist:(NSInteger)index
{
    FileManager *manager = [self getFilemanager];
    NSMutableArray *info = [[self getFilemanager] getDictWithFilePath:manager.unCompletePath];
    NSDictionary *dict = info[index];
    [manager addNewFile:dict filePath:manager.completePath];
    [manager removeInfo:index path:manager.unCompletePath];
}

-(FileManager*)getFilemanager
{
    return [[FileManager alloc]init];
}
@end
