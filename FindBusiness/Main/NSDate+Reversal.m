//
//  NSDate+Reversal.m
//  CollectMoneyTool
//
//  Created by 星空浩 on 2016/10/20.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "NSDate+Reversal.h"

@implementation NSDate (Reversal)
+(NSString*)toString:(NSString*)timeStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/ 1000.0];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}
+(NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}
+(NSString*)toDate:(NSString*)dateStr
{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}
+(NSString*)stringFromDate:(NSDate*)date onFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:format];
    
    return [outputFormatter stringFromDate:date];
}
@end
