//
//  FileManager.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FileManager : NSObject

@property(nonatomic,strong)NSString*completePath;
@property (nonatomic,strong)NSString*unCompletePath;
@property (nonatomic,strong)NSString*downloadPath;

-(void)addNewFile:(NSDictionary*)item filePath:(NSString*)filePath;
//-(void)getdataWithUrl:(NSString*)url;
-(NSString*)getFilePath:(NSString*)name;
-(NSData*)getDataWithFilePath:(NSString*)filePath;
//-(NSMutableArray*)getPlistWithFilePath:(NSString *)filePath;
-(NSMutableArray*)getDictWithFilePath:(NSString *)filePath;

-(void)writeResumeDataToDask:(NSData*)data filePath:(NSString*)filePath;
-(void)removeData:(NSString*)filePath;
-(void)removeInfo:(NSInteger)index path:(NSString*)filePath;
-(NSString*)getDownLoadPath;
@end
