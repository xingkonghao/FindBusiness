//
//  NSDate+Reversal.h
//  CollectMoneyTool
//
//  Created by 星空浩 on 2016/10/20.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Reversal)
+(NSString*)toString:(NSString*)timeStr;//时间戳转时间
+(NSString*)toDate:(NSString*)dateStr;//时间转时间戳
+(NSString*)dateToString:(NSDate*)date;//date转字符串

+(NSString*)stringFromDate:(NSDate*)date onFormat:(NSString *)format;

@end
