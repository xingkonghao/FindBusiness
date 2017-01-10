//
//  TakePhotoViewController.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/10.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class TakePhotoViewController;

@protocol CustomImagePickerControllerDelegate <NSObject>

- (void)customImagePickerController:(TakePhotoViewController *)picker didFinishPickingImage:(UIImage *)image;

@end
@interface TakePhotoViewController : UIViewController

@property(nonatomic)NSUInteger orietation;

@property (weak ,nonatomic) id <CustomImagePickerControllerDelegate> delegate;

@property (nonatomic, strong)       AVCaptureSession            * session;
//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递

@property (nonatomic, strong)       AVCaptureDeviceInput        * videoInput;
//AVCaptureDeviceInput对象是输入流

@property (nonatomic, strong)       AVCaptureStillImageOutput   * stillImageOutput;
//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了

@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  * previewLayer;
//预览图层，来显示照相机拍摄到的画面

@property (nonatomic, strong)       UIBarButtonItem             * toggleButton;
//切换前后镜头的按钮

@property (nonatomic, strong)       UIButton                    * shutterButton;
//拍照按钮

@property (nonatomic, strong)       UIButton                    * cancelButton;
//取消按钮

@property (nonatomic, strong)       UIButton                    * doneButton;
//使用按钮

@property (nonatomic, strong)       UIView                      * cameraShowView;
//放置预览图层的View

@property (nonatomic, strong)       UIImageView                 * resultImageView;
//放置结果图层的View
@property (nonatomic, strong)       UIButton                      *catogoryButton;

@property (nonatomic, strong)        UILabel                    *imageNum;
-(instancetype)initWithParams:(NSDictionary*)parmas;
@end
