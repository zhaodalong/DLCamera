//
//  DLViewController.m
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import "DLViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "DLCameraTopView.h"
#import "DLCameraBottomView.h"
#import "DLShowImageView.h"

@interface DLViewController ()<DLCameraTopViewDelegate, DLCameraBottomViewDelegate, DLShowImageViewDelegate>
    
@property(strong, nonatomic) AVCaptureDevice *device;
@property(strong, nonatomic) AVCaptureDeviceInput *input;
@property(strong, nonatomic) AVCaptureMetadataOutput *output;
@property(strong, nonatomic) AVCaptureStillImageOutput *photoOutput;
@property(strong, nonatomic) AVCaptureSession *session;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property(strong, nonatomic) DLCameraBottomView *bottomView;
@property(strong, nonatomic) DLShowImageView *showImage;
@property(strong, nonatomic) UIView *focusView;
@property(strong, nonatomic) UIImage *image;
@property(assign, nonatomic) BOOL isCanUseCamera;
@property(assign, nonatomic) BOOL isFlashOn;
@property(assign, nonatomic) BOOL isFront;

@property(strong, nonatomic) UILabel *waterMark;

@end

@implementation DLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCanUseCamera = [self canUseCamera];
    if (_isCanUseCamera) {
        [self initCamera];
        [self initSubViews];
    }else {
        return;
    }
}

#pragma mark - 布局
-(void)initSubViews{
    
    _isFront = false;
    
    //顶部视图 - 闪光灯  交换摄像头
    DLCameraTopView *topView = [[DLCameraTopView alloc]initWithFrame:CGRectMake(0, 0, M_S.width, 100)];
    topView.delegate = self;
    [self.view addSubview:topView];
    
    //底部视图 - 取消 拍照
    _bottomView = [[DLCameraBottomView alloc]initWithFrame:CGRectMake(0, M_S.height-100, M_S.width, 100)];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    //焦点视图
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor = [UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;

    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - DLCameraTopViewDelegate
- (void)flashOnAction:(UIButton *)sender {
    if ([_device lockForConfiguration:nil]) {
        UIButton *flashBtn = (UIButton *)sender;
        if (_isFlashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isFlashOn = NO;
                [flashBtn setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isFlashOn = YES;
                [flashBtn setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }

        [_device unlockForConfiguration];
    }
}

- (void)changeCameraAction {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
            _isFront = false;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
            _isFront = YES;
        }
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if(newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            }else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        }else if(error) {
            NSLog(@"toggle camera failed, error = %@",error);
        }
    }
}

#pragma mark - DLCameraBottomViewDelegate
- (void)takePhotoAction{
    AVCaptureConnection *videoConnection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    [self.photoOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        weakSelf.image = [UIImage imageWithData:imageData];
        [weakSelf.session stopRunning];
        
        weakSelf.showImage = [[DLShowImageView alloc]initWithFrame:weakSelf.view.bounds];
        weakSelf.showImage.delegate = self;
        [weakSelf.showImage setImageToImageView: weakSelf.image isFront:weakSelf.isFront];
        [weakSelf.view addSubview:weakSelf.showImage];
        NSLog(@"image size = %@",NSStringFromCGSize(weakSelf.image.size));
    }];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DLShowImageViewDelegate
- (void)sureAction {
    
}

-(void)cancelBtnAction {
    [_showImage removeFromSuperview];
    _showImage = nil;
    [self.session startRunning];
}

#pragma mark - 内部方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices;
    if(@available(iOS 10.0, *)){
        AVCaptureDeviceDiscoverySession *ios10Devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        devices = ios10Devices.devices;
    }else {
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    }
    
    for ( AVCaptureDevice *device in devices ){
        if ( device.position == position ) return device;
    }
    return nil;
}

-(void)focusGesture:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    [self focusAtPoint:point];
}

-(void)focusAtPoint:(CGPoint)point {
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake(point.y/size.height, 1-point.x/size.width);
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                weakSelf.focusView.hidden = YES;
            }];
        }];
    }
}

#pragma mark - 初始化相机
-(void)initCamera{
    self.view.backgroundColor = [UIColor whiteColor];
       
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
       
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
       
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.photoOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
           
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
           
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
       
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
       
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 100, M_S.width, M_S.height-200);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    _waterMark = [[UILabel alloc]initWithFrame:CGRectMake(30, M_S.height-100-60, 100, 30)];
    _waterMark.text = @"水印";
    _waterMark.textColor = [UIColor whiteColor];
    [self.view addSubview:_waterMark];
       
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

#pragma mark - 检查相机权限
-(BOOL)canUseCamera{
    AVAuthorizationStatus state = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (state == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 10.0, *)) {
                if ([[UIApplication sharedApplication]  canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }else {
                if ([[UIApplication sharedApplication]  canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }else {
        return  YES;
    }
}

@end
