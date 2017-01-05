//
//  DownloadManager.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^progressBlock)(NSProgress *downloadProgress,NSDictionary *model);
typedef void(^completeHandler)(NSDictionary*model);
@interface DownloadManager : NSObject
@property(nonatomic,copy)progressBlock progressBlock;
@property (nonatomic,copy)completeHandler completeHandler;
+(instancetype)shareManager;

-(void)addNewDownloadTask:(NSString*)url;
-(void)removeDownloadTask:(NSInteger)index;
-(void)pasueDownloadTask:(NSInteger)index;
-(void)reseumeDownloadTask:(NSInteger)index;
-(void)getProgress:(progressBlock)progressBlock;
-(void)completeHandler:(completeHandler)block;
@end
