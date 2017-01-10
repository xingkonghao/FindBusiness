//
//

#import <Foundation/Foundation.h>
@class DownloadModel;
@interface NetWorkManager : NSObject
+ (instancetype)sharedInstance;


/**
 *  同步请求
 *
 *  @param RequestType POST or GET
 *  @param URL        地址
 *  @param parameters 参数
 *  @param Controller 控制器
 *  @param success
 *
 */
- (void)SynchronizationForRequestType:(NSString *)RequestType WithURL:(NSString *)URL parameters:(NSString *)parametersStr Controller:(UIViewController *)Controller success:(void(^)(id response,id data))success;
/**
 *  上传图片
 *
 *  @param image   上传图片
 *  @param url     地址
 *  @param userid  用户id
 *  @param success 成功block
 *  @param failure 失败block
 */
-(void)UploadPicturesToServerPic:(UIImage *)image url:(NSString *)url parameters:(id)parameters progress:(void(^)(CGFloat progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *  error))failure;

/**
 *  请求图片信息的地址
 *
 *  @param url     地址
 *  @param failure 失败block
 */
- (void)getPictureUrl:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *  error))failure;
/**
 *  Post请求
 *
 *  @param URL        地址
 *  @param parameters 参数
 *  @param Controller 控制器
 *  @param success
 *  @param failure
 */
- (void)requestDataForPOSTWithURL:(NSString *)URL parameters:(id)parameters Controller:(UIViewController *)Controller success:(void(^)(id responseObject))success failure:(void (^)(NSError *  error))failure;
/**
 *  get请求
 *
 *  @param URL        地址
 *  @param Controller 控制器
 *  @param success
 *  @param failure
 */
-(void)requestDataForGETWithURL:(NSString *)URL parameters:(id)parameters Controller:(UIViewController *)Controller success:(void(^)(id responseObject))success failure:(void (^)(NSError *  error))failure;
/**
 *  上传文件
 *
 *  @param fileData 图片组
 *  @param params   其他参数
 *  @param result   成功回调
 *  @param failure  失败回调
 */
- (NSURLSessionDataTask*)updateFile:(NSArray*)fileData url:(NSString*)url parameters:(NSMutableDictionary*)params viewControler:(UIViewController*)vc success:(void(^)(id result))result failure:(void(^)(NSError *  error))failure;
/**
 *  清除用户信息
 */
-(void)clearUserCaches;
/**
 *断点下载
 */
-(NSURLSessionDataTask*)downloadFileWithUrl:(NSDictionary*)dict taskIndex:(NSInteger)taskIndex progress:(void (^)(NSProgress *downloadProgress,NSDictionary*model))downloadProgressBlock completeHandler:(void(^)(BOOL isSuccess,NSDictionary*model))completeHandler ;

@end
