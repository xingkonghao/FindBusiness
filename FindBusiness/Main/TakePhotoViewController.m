//
//  TakePhotoViewController.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/10.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "FileManager.h"
#define BarWidth  100
@interface TakePhotoViewController ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray *_exampleArr;
    FileManager *_fileManager;
    NSString *_currentCategory;
}
@property(nonatomic,strong)NSDictionary *params;
@property (nonatomic,strong)NSArray *categoryArr;
@property (nonatomic,strong)UITableView *categoryTab;
@end

@implementation TakePhotoViewController
-(instancetype)initWithParams:(NSDictionary*)parmas;
{
    if (self = [super init]) {
        self.params = parmas;
        _fileManager = [[FileManager alloc]init];
        self.categoryArr = @[@"大门及周边",@"主要建筑",@"车间及设备",@"仓储及存货",@"消防安保",@"电气灯具",@"其他照片"];
        _currentCategory = @"大门及周边";
        _exampleArr = @[@"demo_dmjzb",@"demo_zyjz",@"demo_cjjsb",@"demo_ccjch",@"demo_xfab",@"demo_dqdj",@"demo_qtzp"];
    }
    return self;
}
-(UITableView*)categoryTab
{
    if (!_categoryTab) {
        _categoryTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - BarWidth-120,0, 120, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _categoryTab.backgroundColor = [UIColor whiteColor];
        _categoryTab.delegate = self;
        _categoryTab.dataSource = self;
        
        [self.view addSubview:_categoryTab];
    }
    _categoryTab.hidden = NO;
    return _categoryTab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialSession];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}
-(void)setupView
{
    //放置预览图层的View
    _cameraShowView = [[UIView alloc]init];
    _cameraShowView.frame = CGRectMake(0, 0 ,SCREEN_HEIGHT, SCREEN_WIDTH);
    [self.view addSubview:_cameraShowView];
    
    NSLog(@"%f %f",SCREEN_HEIGHT,SCREEN_WIDTH);
    
    //显示拍照结果
    _resultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH-108,108*16/9.0,108)];
    _resultImageView.backgroundColor = [UIColor clearColor];
    _resultImageView.image = [UIImage imageNamed:_exampleArr[0]];
    [self performSelector:@selector(imageHidden) withObject:nil afterDelay:2];
    [self.view addSubview:_resultImageView];
    
    
    UIView *BarView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-BarWidth,0, BarWidth, SCREEN_WIDTH)];
    BarView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:BarView];
    
    //商机名称
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0,10,BarWidth, 20)];
    nameLab.text = _params[@"name"];
    nameLab.textColor = MainColor;
    nameLab.font = [UIFont systemFontOfSize:12];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [BarView addSubview:nameLab];
    //拍照按钮
    self.shutterButton = [UIButton buttonWithType:0];
    self.shutterButton.frame = CGRectMake(25, SCREEN_WIDTH/2.0-25, 50, 50);
    [self.shutterButton setImage:[UIImage imageNamed:@"img_take_photo1"] forState:UIControlStateNormal];
    [BarView addSubview:self.shutterButton];
    
    [self.shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    
    //类别选择按钮
    self.catogoryButton = [UIButton buttonWithType:0];
    self.catogoryButton.frame = CGRectMake(0, 50,BarWidth, 50);
    [self.catogoryButton setTitle:_categoryArr[0] forState:UIControlStateNormal];
    [self.catogoryButton setTitleColor:MainColor forState:UIControlStateNormal];
    self.catogoryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [BarView addSubview:self.catogoryButton];
    
    [self.catogoryButton addTarget:self action:@selector(catogorySelect:) forControlEvents:UIControlEventTouchUpInside];
    //照片数量
    _imageNum = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.catogoryButton.frame)+10,BarWidth, 20)];
    _imageNum.text = @"总剩余张数：60";
    _imageNum.textColor = MainColor;
    _imageNum.font = [UIFont systemFontOfSize:12];
    _imageNum.textAlignment = NSTextAlignmentCenter;
    [BarView addSubview:_imageNum];
    
    //照明灯按钮
    self.doneButton = [UIButton buttonWithType:0];
    self.doneButton.frame = CGRectMake(0, 0, 50, 50);
    [self.doneButton setImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [self.doneButton setImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    
    [self.view addSubview:self.doneButton];
    
    [self.doneButton addTarget:self action:@selector(lightSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(25,SCREEN_WIDTH - 80, 50, 50);
    [self.cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [BarView addSubview:self.cancelButton];
    
    [self.cancelButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpCameraLayer];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}
#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT/7.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    }
    cell.textLabel.frame = CGRectMake(0, 0, BarWidth, SCREEN_HEIGHT/7.0);
    cell.textLabel.text = self.categoryArr[indexPath.row];
    cell.textLabel.textColor = MainColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = MainColor;
    [self.catogoryButton setTitle:self.categoryArr[indexPath.row] forState:UIControlStateNormal];
    _resultImageView.image = [UIImage imageNamed:_exampleArr[indexPath.row]];
    _resultImageView.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(imageHidden) object:nil];

    [self performSelector:@selector(imageHidden) withObject:nil afterDelay:3.0];
}
-(void)imageHidden
{
    _resultImageView.hidden = YES;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = MainColor;
    cell.backgroundColor = [UIColor whiteColor];
}
- (void) initialSession{
    
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //    [self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    AVCaptureConnection *output2VideoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    output2VideoConnection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];

}

- (void) setUpCameraLayer{
    
    if (self.previewLayer == nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        [self.previewLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        self.previewLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
}


- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
    }
    
    return AVCaptureVideoOrientationLandscapeLeft;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - actions

- (void)closeView{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setOrientationPortrait" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}
-(void)catogorySelect:(UIButton*)btn
{
    self.categoryTab.hidden = btn.selected;
    btn.selected = !btn.selected;
}
- (void) shutterCamera{
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        [_fileManager writeImageToDisk:imageData imageName:self.params[@"name"]];
     
//        UIImage * image = [UIImage imageWithData:imageData];
////        self.resultImageView.image = image;
//        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
    }];
}

- (void)lightSwitch:(UIButton*)tap{
    tap.selected = !tap.selected;
    [self setEnableTorch:tap.selected];
    
}
- (void)setEnableTorch:(BOOL)enableTorch
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        if (enableTorch) { [device setTorchMode:AVCaptureTorchModeOn]; }
        else { [device setTorchMode:AVCaptureTorchModeOff]; }
        [device unlockForConfiguration];
    }
}

#pragma mark Orientations
- (BOOL)shouldAutorotate{
    
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeLeft;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

