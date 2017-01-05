//
//
#define  KEY_DEVICE_UUID @"KEY_DEVICE_UUID"


#import "NetWorkManager.h"
#define kTimeoutInterval  60.f
#import "FileManager.h"
/**
 *  取
 */
#define kCookieID_KEY @"Cookie_key"

@interface NetWorkManager ()<UIAlertViewDelegate>

@property(nonatomic,strong)UIAlertView *myAlert;

@end


@implementation NetWorkManager
static NetWorkManager *network = nil;
+ (instancetype)sharedInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[super allocWithZone:NULL] init];
        
    });
    return network;
}
//-(NSString *)getUUID
//{
//    NSString * strUUID = (NSString *)[SPIMyUUID load:KEY_DEVICE_UUID];
//    
//    if ([strUUID isEqualToString:@""] || !strUUID)
//    {
//        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//        
//        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
//        
//        [SPIMyUUID save:KEY_DEVICE_UUID data:strUUID];
//        
//    }
//    return strUUID;
//    
//    
//}
//- (void)SynchronizationForRequestType:(NSString *)RequestType WithURL:(NSString *)URL parameters:(NSString *)parametersStr Controller:(UIViewController *)Controller success:(void(^)(id response,id data))success
//{
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YGBaseURL,URL]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:RequestType];
//    
//    [request setValue:[USER_ID stringValue] forHTTPHeaderField:@"uid"];
//    [request setValue:kVersion forHTTPHeaderField:@"version"];
//    [request setValue:[self getUUID] forHTTPHeaderField:@"EquipmentOnlyLabeled"];
////    NSArray *temp_array = [NAMEANDPWFORBASIC componentsSeparatedByString:@"#"];
////    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", temp_array[0], temp_array[1]] dataUsingEncoding:NSUTF8StringEncoding];
////    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
////    [request setValue:[NSString stringWithFormat:@"Basic %@", base64AuthCredentials] forHTTPHeaderField:@"Authorization"];
//    
//    if (parametersStr) {
//        
//        NSData *data = [parametersStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//        [request setHTTPBody:data];
//    }
//    
//    dispatch_semaphore_t disp = dispatch_semaphore_create(0);
//    
//    
//    NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        
//        
//        success (response,data);
//        
//        
//        
//        dispatch_semaphore_signal(disp);
//    }];
//    
//    
//    [dataTask resume];
//    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
//}






-(void)UploadPicturesToServerPic:(UIImage *)image url:(NSString *)url parameters:(id)parameters progress:(void(^)(CGFloat progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *  error))failure
{
//    url = [NSString stringWithFormat:@"%@%@",ImageBaseURL,url];
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss_"];
        NSString *picname = [formatter stringFromDate:now];
        
        NSString *path = NSTemporaryDirectory();
        NSString *file = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d(DFYG-CollectMoneyTool)_%@.png",arc4random()%1000,picname]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.06);
        
        [formData appendPartWithFileData:imageData name:@"profile" fileName:file mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
       
       if (progress) {
          progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
       }
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success (responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            failure(error);
        }
        
    }];
    
}

-(void)requestDataForPOSTWithURL:(NSString *)URL parameters:(id)parameters Controller:(UIViewController *)Controller success:(void(^)(id responseObject))success failure:(void (^)(NSError *  error))failure
{
    if ([kNetworkType isEqualToString:kNoNetwork]) {
        failure(nil);
        return;
    }
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
//    URL = [NSString stringWithFormat:@"%@%@",YGBaseURL,URL];
    
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /**
         *  get Cookies
         */
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        if (![NSString isBlankString:[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]]]) {
//            
//            if (!USER_TOKENID) {
//                
//                /**
//                 *   登录先存储用于比对相应的headerfile
//                 */
//                [[AppSingle Shared]saveInMyLocalStoreForValue:[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]] atKey:KEY_USER_TOKENID];
//                
//            }else
//            {
//                /**
//                 *  登录后比对相应的headerfile
//                 */
////                if (![[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]] isEqualToString:USER_TOKENID]) {
////                    
////                }
//                [self alertShowWith:Controller];
//            }
//            NSLog(@"login  ---> %@",response.allHeaderFields);
//            NSLog(@"login  ---> cookie %@",response.allHeaderFields[@"Set-Cookie"]);
//            
//        }
        
        
        
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}
-(void)requestDataForGETWithURL:(NSString *)URL parameters:(id)parameters Controller:(UIViewController *)Controller success:(void(^)(id responseObject))success failure:(void (^)(NSError *  error))failure
{
    
    if ([kNetworkType isEqualToString:kNoNetwork]) {
        failure(nil);
        return;
    }
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    
    
    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /**
         *  get Cookies
         */
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        if (![NSString isBlankString:[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]]]) {
//            
//            /**
//             *  登录后比对相应的headerfile
//             */
////            if (![[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]] isEqualToString:USER_TOKENID]) {
////                
////            }
//            [self alertShowWith:Controller];
//            NSLog(@"login  ---> %@",response.allHeaderFields);
//            NSLog(@"login  ---> cookie %@",response.allHeaderFields[@"Set-Cookie"]);
//        }
        
        
        if (success) {
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}
- (AFHTTPSessionManager *)HTTPSessionManager{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /**
     *  先删除cookies
     */
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;//默认 NSUTF8StringEncoding
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    securityPolicy.allowInvalidCertificates = YES;
   
    manager.securityPolicy = securityPolicy;
    
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/xml",@"text/plain"]];
//    
//    manager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

   // [manager.requestSerializer setValue:USER_ID forHTTPHeaderField:@"uid"];
  //  [manager.requestSerializer setValue:[self getUUID] forHTTPHeaderField:@"EquipmentOnlyLabeled"];
  //  [manager.requestSerializer setValue:kVersion forHTTPHeaderField:@"version"];
//    if (USER_TOKENID) {
//        
//        [manager.requestSerializer setValue:USER_TOKENID forHTTPHeaderField:@"Cookie"];
//    }
//    NSArray *temp_array = [NAMEANDPWFORBASIC componentsSeparatedByString:@"#"];
//    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:temp_array[0] password:temp_array[1]];
    
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.operationQueue.maxConcurrentOperationCount = 2;
    
    [manager.responseSerializer willChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setTimeoutInterval:kTimeoutInterval];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}
/**
 *  配置请求头
 *
 *  @return NSString
 */
//-(NSString *)getRequestHeaderParameter
//{
//    return [NSString stringWithFormat:@"uid=%@;version=%@",USER_ID,kVersion];
//}

- (void)getPictureUrl:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *  error))failure;
{
    if ([kNetworkType isEqualToString:kNoNetwork]) {
        failure(nil);
        return;
    }

    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /**
         *  get Cookies
         */
        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        //        if (![NSString isBlankString:[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]]]) {
        //
        //            /**
        //             *  登录后比对相应的headerfile
        //             */
        ////            if (![[self getUserTokenIdInCookie:response.allHeaderFields[@"Set-Cookie"]] isEqualToString:USER_TOKENID]) {
        ////
        ////            }
        //            [self alertShowWith:Controller];
        //            NSLog(@"login  ---> %@",response.allHeaderFields);
        //            NSLog(@"login  ---> cookie %@",response.allHeaderFields[@"Set-Cookie"]);
        //        }
        
        
        if (success) {
            success(responseObject);
            
        }        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];

}
- (NSURLSessionDataTask*)updateFile:(NSArray*)fileData url:(NSString*)url parameters:(NSMutableDictionary*)params fileName:(NSString*)fileName viewControler:(UIViewController*)vc success:(void(^)(id result))result failure:(void(^)(NSError *  error))failure;
{
    
    if ([kNetworkType isEqualToString:kNoNetwork]) {
        failure(nil);
        return nil;
    }

    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];

  return  [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       // int index = 0;
        for(UIImage *image in fileData)
        {
            NSString* tempFileName = [NSString stringWithFormat:@"%@.png",fileName];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            NSLog(@"%fKB",imageData.length/1024.0);
            [formData appendPartWithFileData:imageData name:@"file" fileName:tempFileName mimeType:@"image/png"];
           // index ++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

#pragma mark - alertview
static UIViewController *tempVC = nil;
-(void)alertShowWith:(UIViewController *)VC
{
    tempVC = VC;
    [self.myAlert show];
}
-(UIAlertView *)myAlert
{
    if (!_myAlert) {
        
        _myAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的帐号已在另一台设备登录，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    return _myAlert;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (tempVC) {
        
        tempVC = nil;
        
        [self clearUserCaches];
        [tempVC dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *   解析Cookie获取kTokenID
 */
-(NSString *)getUserTokenIdInCookie:(NSString *)theCookie
{
    //例如 ：JSESSIONID=25F6DBC6AB286542F37D58B8EDBB84BD; Path=/pad, cookie_user=fsdf#~#sdfs.com; Expires=Tue, 26-Nov-2013 06:31:33 GMT, cookie_pwd=123465; Expires=Tue, 26-Nov-2013 06:31:33 GMT
    NSString *basic_str = @"";
//    
//    NSMutableArray *cookisArray=[NSMutableArray arrayWithCapacity:20];
//    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    NSArray *theArray = [theCookie componentsSeparatedByString:@"; "];
    
    for (int i =0 ; i<[theArray count]; i++) {
        
        NSString *val=theArray[i];
        if ([val rangeOfString:@"JSESSIONID="].length>0)
        {
            basic_str = val;
        }
    }
    
    
//    for (int i =0 ; i<[theArray count]; i++) {
//        NSString *val=theArray[i];
//        if ([val rangeOfString:@"="].length>0)
//        {
//            NSArray *subArray = [val componentsSeparatedByString:@"="];
//            for (int i =0 ; i<[subArray count]; i++) {
//                NSString *subVal=subArray[i];
//                if ([subVal rangeOfString:@","].length>0)
//                {
//                    NSArray *subArray2 = [subVal componentsSeparatedByString:@","];
//                    for (int i =0 ; i<[subArray2 count]; i++) {
//                        NSString *subVal2=subArray2[i];
//                        [cookisArray addObject:subVal2];
//                    }
//                }
//                else
//                {
//                    [cookisArray addObject:subVal];
//                }
//            }
//        }
//        else
//        {
//            [cookisArray addObject:val];
//        }
//    }
//    for (int idx=0; idx<cookisArray.count; idx+=2) {
//        NSString *key=cookisArray[idx];
//        NSString *value;
//        if ([key isEqualToString:@"JSESSIONID"])
//        {
//            value=[NSString stringWithFormat:@"%@,%@",cookisArray[idx+1],cookisArray[idx+2]];
//            idx+=1;
//        }
//        else
//        {
//            value=cookisArray[idx+1];
//        }
//        NSLog(@"cookie value:%@=%@",key,value);
//        [cookieProperties setObject:value forKey:key];
//    }
    
    
    return basic_str;
}
-(void)clearUserCaches
{
   // [APPSINGLE DeleteValueInMyLocalStoreForKey:KEY_USER_ID];
}
//断点下载
-(NSURLSessionDownloadTask*)downloadFileWithUrl:(NSDictionary*)dict taskIndex:(NSInteger)taskIndex progress:(void (^)(NSProgress *downloadProgress,NSDictionary*model))downloadProgressBlock completeHandler:(void(^)(BOOL isSuccess,NSDictionary*model))completeHandler ;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSData *resueData = [NSData dataWithContentsOfFile:dict[@"resueDataPath"]];
    __block NSDictionary *tempDict = dict;
    if (!resueData) {//本地是否有数据
        NSURL *URL = [NSURL URLWithString:dict[@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        return [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            downloadProgressBlock(downloadProgress,tempDict);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            FileManager *manager = [[FileManager alloc]init];
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.PDF",manager.downloadPath,[NSString md5:tempDict[@"url"] ]]];

        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                completeHandler(YES,tempDict);
            }
        }];
    }
    
    
    return [manager downloadTaskWithResumeData:[NSData new] progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
       
        return [NSURL fileURLWithPath:tempDict[@"destinationPath"]];

    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
}

@end
