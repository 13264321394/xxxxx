//
//  CustomButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "CustomButton.h"
//#import "TipsView.h"

//网站主部署的用于验证注册的接口 (api_1)
//#define api_1 @"http://www.geetest.com/demo/gt/register-slide"
//网站主部署的二次验证的接口 (api_2)
//#define api_2 @"http://www.geetest.com/demo/gt/validate-slide"

@interface CustomButton () <GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

@property (nonatomic, strong) GT3CaptchaManager *manager;

@property (nonatomic, assign) NSInteger index;

@end

@implementation CustomButton

- (GT3CaptchaManager *)manager {
    if (!_manager) {
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSString *api_1=[NSString stringWithFormat:@"http://vectwallet.com/gt/register4?uuid=%@&typeId=1", myUUIDStr];
        
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        _manager.delegate = self;
        //_manager.viewDelegate = self;
        
        //[_manager enableDebugMode:YES];
        [_manager useVisualViewWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    
    return _manager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)_init {
    
    // 必须调用, 用于注册获取验证初始化数据
    [self setUserInteractionEnabled:NO];
    [self.manager registerCaptcha:nil];
}

- (void)startCaptcha {
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonShouldBeginTapAction:)]) {
        if (![_delegate captchaButtonShouldBeginTapAction:self]) {
            return;
        }
    }
    
    [self.manager startGTCaptchaWithAnimated:YES];
}

- (void)stopCaptcha {
    
    [self.manager stopGTCaptcha];
}

#pragma mark GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    //[TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    
    NSLog(@"User Did Close GTView.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"处理你的验证结果CustomButton\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        //[TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(captcha:didReceiveSecondaryCaptchaData:response:error:)]) {
        [_delegate captcha:manager didReceiveSecondaryCaptchaData:data response:response error:error];
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init]timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
}

@end



