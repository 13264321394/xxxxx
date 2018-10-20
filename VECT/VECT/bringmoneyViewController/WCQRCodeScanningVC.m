//
//  WCQRCodeScanningVC.m
//  VECT
//
//  Created by 方墨 on 2018/5/29.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "WCQRCodeScanningVC.h"
#import "SGQRCodeGenerateManager.h"
#import "SGQRCodeScanManager.h"
#import "SGQRCodeAlbumManager.h"
#import "SGQRCodeScanningView.h"
#import "SGQRCodeHelperTool.h"
//#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "scansshowViewController.h"
#import "Masonry.h"

@interface WCQRCodeScanningVC ()<SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong)UIButton *netabutton;

@end

@implementation WCQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    NSLog(@"WCQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    [self.view addSubview:self.scanningView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //[self.view addSubview:self.scanningView];//扫描区域
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.view.backgroundColor = [UIColor clearColor];
                            self.netabutton.userInteractionEnabled=YES;
                            [self.netabutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                            [self.view addSubview:self.scanningView];
                            [self setupQRCodeScanning];
                            [self.view addSubview:self.promptLabel];
                            /// 为了 UI 效果
                            [self.view addSubview:self.bottomView];
                            
                            [self setupNavigationBar];
                        });
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.view.backgroundColor=[UIColor whiteColor];
                           [self setupNavigationBar]; self.netabutton.userInteractionEnabled=NO;
                            [self.netabutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"如果你想使用VECT二维码扫描，请前往手机桌面-> [设置 - 隐私 - 相机 - VECT] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                NSLog(@"用户第一次同意应用访问相册");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.netabutton.userInteractionEnabled=YES;
                    [self.netabutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    self.view.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:self.scanningView];
                    [self setupQRCodeScanning];
                    [self.view addSubview:self.promptLabel];
                    /// 为了 UI 效果
                    [self.view addSubview:self.bottomView];
                    [self setupNavigationBar];
                });
                break;
            }
            case AVAuthorizationStatusDenied: {
                NSLog(@"用户第一次拒绝应用访问相册");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    self.view.backgroundColor = [UIColor orangeColor];
                    [self setupNavigationBar];
                    self.netabutton.userInteractionEnabled=NO;
                    [self.netabutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"前往手机桌面-> [设置 - 隐私 - 相机 - VECT] 打开访问开关，就可以使用二维码扫描了" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:action];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupNavigationBar];
                    self.netabutton.userInteractionEnabled=NO;
                    [self.netabutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    self.view.backgroundColor = [UIColor whiteColor];
            
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"因为系统原因, 无法访问相册" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:action];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    
    //[self setupQRCodeScanning];//相机区域
    
    //[self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    //[self.view addSubview:self.bottomView];
    
    //[self setupNavigationBar];
    
    
    // Do any additional setup after loading the view.
}


- (void)setupNavigationBar {
    
    UIView *view0=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
    view0.backgroundColor=[UIColor whiteColor];
    //view0.alpha=0.6;
    [self.view addSubview:view0];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"扫一扫";
    forgetPawLabel.textColor=[UIColor blackColor];
    forgetPawLabel.font=[UIFont systemFontOfSize:18.5f];
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [view0 addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [view0 addSubview:backbutton];

    self.netabutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*4/5, StatusbarHeight+7, GZDeviceWidth/5, 30)];
    [self.netabutton setTitle:@"相 册" forState:UIControlStateNormal];
    self.netabutton.titleLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    [self.netabutton setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.netabutton addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    [view0 addSubview:self.netabutton];
    
}

-(void)backMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
    }
    
    return _scanningView;
}

- (void)removeScanningView {
    
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    
    NSLog(@"点击了相册");
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [self.manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    self.manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    
    [self.view addSubview:self.scanningView];
}

//相册中扫描到结果后
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_URL = result;
        //[self.navigationController pushViewController:jumpVC animated:YES];
        [self presentViewController:jumpVC animated:YES completion:nil];
    } else {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_bar_code = result;
        //[self.navigationController pushViewController:jumpVC animated:YES];
        [self presentViewController:jumpVC animated:YES completion:nil];
    }
}

- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    
    NSLog(@"相册里暂未识别出二维码");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/4)/2, GZDeviceHeight/2, GZDeviceWidth*3/4, 20+GZDeviceHeight/25)];
        theLabel.backgroundColor=[UIColor whiteColor];
        theLabel.layer.cornerRadius = 5.f;
        theLabel.clipsToBounds = YES;
        theLabel.textColor=[UIColor blackColor];
        theLabel.alpha=0.8f;
        theLabel.textAlignment=NSTextAlignmentCenter;
        theLabel.font=[UIFont systemFontOfSize:15.f];
        theLabel.text=@"相册里未识别出二维码";
        [self.view addSubview:theLabel];
        
        //设置动画
        CATransition *transion=[CATransition animation];
        transion.type=@"push";//动画方式
        transion.subtype=@"fromRight";//设置动画从哪个方向开始
        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
        //不占用主线程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            [theLabel removeFromSuperview];
            
        });//这句话的意思是1.5秒后，把label移出视图
    });
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
            [scanManager stopRunning];
            [scanManager videoPreviewLayerRemoveFromSuperlayer];
            
            NSLog(@"只打印一次");
        });
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_URL = [obj stringValue];
        NSString *mystr=[NSString stringWithFormat:@"%@", [obj stringValue]];
        NSLog(@"next扫描到的返回数据==%@", jumpVC.jump_URL);
        
        //利用通知进行反向传值
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZYNotiSendValue" object:nil userInfo:@{@"value":mystr}];
        
        scansshowViewController *shv=[[scansshowViewController alloc] init];
        shv.scansshowStr=[NSString stringWithFormat:@"%@", jumpVC.jump_URL];
        [self presentViewController:shv animated:YES completion:nil];
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.81*GZDeviceHeight;
        CGFloat promptLabelW = GZDeviceWidth;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.textColor=[UIColor greenColor];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage.png"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage.png"] forState:(UIControlStateSelected)];
        //_flashlightBtn.backgroundColor=[UIColor redColor];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
