//
//  FileManager.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FileManager : NSObject

+(void)addItem:(NSDictionary*)item;
+(void)addLimitNum:(NSDictionary*)item;
+(NSArray*)getItems;
+(NSDictionary*)getLimitData;
@end
