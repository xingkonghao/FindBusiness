//
//  FileManager.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZipArchive.h>
@interface FileManager : NSObject

+(void)addItem:(NSDictionary*)item;
+(void)deleteItem:(NSDictionary*)item;
+(NSArray*)getItems;
+(void)addLimitNum:(NSDictionary*)item;
+(NSDictionary*)getLimitData;
+(NSArray*)getCategotysUnderBusiness:(NSString*)businessName;
+(NSArray*)getitemUnderCategory:(NSString*)category businessName:(NSString*)businessName;
+(NSString*)getdataPath:(NSString*)dataName category:(NSString*)category businessName:(NSString*)businessName;
+(void)writeData:(NSData*)data toDiskWithBusinessName:(NSString*)businessName category:(NSString*)category;

+(NSData*)zipData:(NSDictionary*)item object:(id)obj;
+(NSString*)getDataName:(NSDictionary*)item;
+(NSString*)getUserUM;
+(void)deleteFile:(NSDictionary*)item;
+(BOOL)deleteImage:(NSInteger)index item:(NSDictionary*)item;
@end
