//
//  FilteredWebCache.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/3.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "FilteredWebCache.h"

@implementation FilteredWebCache

-(NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    NSLog(@"%@",url.absoluteString);
//    if (blockURL) {
//        NSURLResponse *response =
//        [[NSURLResponse alloc] initWithURL:url
//                                  MIMEType:@"text/plain"
//                     expectedContentLength:1
//                          textEncodingName:nil];
//        NSCachedURLResponse *cachedResponse =
//        [[NSCachedURLResponse alloc] initWithResponse:response
//                                                 data:[NSData dataWithBytes:" " length:1]];
//        [super storeCachedResponse:cachedResponse forRequest:request];
//
//    }
    return [super cachedResponseForRequest:request];
}

@end
