//
//  chargemoneyViewController.m
//  VECT
//
//  Created by 方墨 on 2018/7/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "chargemoneyViewController.h"
#import "BaseTextField.h"
#import "Masonry.h"

@interface chargemoneyViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *addresstextField;
@property(nonatomic,strong)UITextField *amounttextField;

@property(nonatomic,strong)UIButton *copytheaddressButton;

@end

@implementation chargemoneyViewController

-(void)viewWillAppear:(BOOL)animated
{
    //生成二维码图片
    [self generateqrcodes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"充币地址";
    realnameLabel.textAlignment = NSTextAlignmentCenter;
    realnameLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/35];
    [self.view addSubview:realnameLabel];
    [realnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    UIView *grayView=[[UIView alloc] init];
    grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44)));
    }];
    
    UIView *qrcode=[[UIView alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*2/5)/2, StatusbarHeight+44+GZDeviceHeight/15, GZDeviceWidth*2/5, GZDeviceWidth*2/5)];
    qrcode.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:qrcode];
    
    UILabel *collectqrcodeLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, StatusbarHeight+44+GZDeviceHeight/15+GZDeviceWidth*2/5+GZDeviceHeight/50, GZDeviceWidth/2, 30)];
    collectqrcodeLabel.text=@"收款二维码";
    collectqrcodeLabel.font=[UIFont systemFontOfSize:15.f];
    collectqrcodeLabel.textColor=[UIColor lightGrayColor];
    collectqrcodeLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:collectqrcodeLabel];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*0.55, GZDeviceWidth-2*10, GZDeviceHeight/6)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    UIButton *copytheaddressButton=[[UIButton alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*0.55+GZDeviceHeight/6+GZDeviceHeight/30, GZDeviceWidth-2*10, 20+GZDeviceHeight/28)];
    [copytheaddressButton setTitle:@"复制地址" forState:UIControlStateNormal];
    copytheaddressButton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
    copytheaddressButton.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
    [copytheaddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copytheaddressButton addTarget:self action:@selector(copytheaddressMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copytheaddressButton];
    self.copytheaddressButton=copytheaddressButton;
    self.copytheaddressButton.enabled=YES;
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/6/2-0.5, GZDeviceWidth-2*10, 1)];
    view2.backgroundColor=[UIColor lightGrayColor];
    [view1 addSubview:view2];
    
    
    UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(23, 0, 42, GZDeviceHeight/6/2-0.5)];
    addressLabel.text=@"地址:";
    addressLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    //addressLabel.backgroundColor=[UIColor cyanColor];
    [view1 addSubview:addressLabel];
    
    UILabel *amountLabel=[[UILabel alloc] initWithFrame:CGRectMake(23, GZDeviceHeight/6/2+0.5, 42, GZDeviceHeight/6/2-0.5)];
    amountLabel.text=@"金额:";
    amountLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    //amountLabel.backgroundColor=[UIColor greenColor];
    [view1 addSubview:amountLabel];
    
    
    UITextField *addresstextField=[[BaseTextField alloc] initWithFrame:CGRectMake(23+42+2, 0, GZDeviceWidth-2*10-23-42-2, GZDeviceHeight/6/2-0.5)];
    //addresstextField.placeholder=@"请输入地址";
    [addresstextField setTextAlignment:NSTextAlignmentLeft];
    addresstextField.adjustsFontSizeToFitWidth = YES;
    [addresstextField setReturnKeyType:UIReturnKeyDone];
    addresstextField.minimumFontSize=16;//设置自动缩小显示的最小字体大小
    [view1 addSubview:addresstextField];
    addresstextField.text=self.codeAddressStr;
    self.addresstextField=addresstextField;
    addresstextField.keyboardType=UIKeyboardTypeNamePhonePad;//电话键盘,可以显示人名
    addresstextField.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    //addresstextField.secureTextEntry = YES;//每输入一个字符就变成点 用语密码输入
    addresstextField.autocorrectionType = UITextAutocorrectionTypeNo;//是否纠错
    addresstextField.clearsOnBeginEditing = NO;//再次编辑就清空
    addresstextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    addresstextField.placeholder=@"请输入地址";
    [addresstextField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    
    
    UITextField *amounttextField=[[BaseTextField alloc] initWithFrame:CGRectMake(23+42+2, GZDeviceHeight/6/2, GZDeviceWidth-2*10-23-42-2, GZDeviceHeight/6/2-0.5)];
    //amounttextField.placeholder=@"请输入金额";
    [amounttextField setTextAlignment:NSTextAlignmentLeft];
    amounttextField.adjustsFontSizeToFitWidth = YES;
    [amounttextField setReturnKeyType:UIReturnKeyDone];
    amounttextField.minimumFontSize=16;//设置自动缩小显示的最小字体大小
    [view1 addSubview:amounttextField];
    self.amounttextField=amounttextField;
    amounttextField.keyboardType=UIKeyboardTypePhonePad;//电话键盘,可以显示人名
    amounttextField.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    //amounttextField.secureTextEntry = YES;//每输入一个字符就变成点 用语密码输入
    amounttextField.autocorrectionType = UITextAutocorrectionTypeNo;//是否纠错
    amounttextField.clearsOnBeginEditing = NO;//再次编辑就清空
    amounttextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    amounttextField.placeholder=@"请输入金额数";
    [amounttextField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    
    self.addresstextField.delegate=self;
    self.amounttextField.delegate=self;
    
    
    //生成二维码图片
    [self generateqrcodes];
    
    // Do any additional setup after loading the view.
}

//生成二维码图片
-(void)generateqrcodes
{
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    //NSString *dataString = @"http://www.baidu.com";
    
    //NSLog(@"金额内容%@", self.amounttextField.text);
    //NSLog(@"地址%@", self.codeAddressStr);
    
    NSString *dataString;
    if (self.amounttextField.text.length==0) {
        dataString = self.codeAddressStr;
    } else {
        dataString = self.amounttextField.text;
    }
    //NSString *dataString = self.codeAddressStr;
    //NSString *dataString = self.amounttextField.text;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    
    // 5.显示二维码
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *QrcodeImageView=[[UIImageView alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*2/5)/2, StatusbarHeight+44+GZDeviceHeight/15, GZDeviceWidth*2/5, GZDeviceWidth*2/5)];
        QrcodeImageView.image=[UIImage imageWithCIImage:outputImage];
        QrcodeImageView.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
        [self.view addSubview:QrcodeImageView];
    });
}

/*
 根据CIImage生成指定大小的UIImage
 @param image CIImage
 @param size  图片宽度
 @return 生成高清的UIImage
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addresstextField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [self.amounttextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑,返回NO时不能唤起键盘进行编辑
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.addresstextField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [self.amounttextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - GZDeviceHeight/4.5, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +GZDeviceHeight/4.5, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"1");//输入文字时 一直监听
    
    //生成二维码图片
    [self generateqrcodes];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"5");// 点击‘x’清除按钮时 调用
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"6");//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    return YES;
}

//UITextField 禁用复制粘贴功能
//重载方法，控制弹出选项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//粘贴
    {
        return NO;
    }
    else if (action == @selector(copy:))//赋值
    {
        return NO;
    }
    else if (action == @selector(select:))//选择
    {
        return NO;
    } else {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}


-(void)copytheaddressMethod
{
    
    self.copytheaddressButton.enabled=NO;
    self.copytheaddressButton.backgroundColor=[UIColor grayColor];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (self.codeAddressStr.length!=0) {
        [pasteboard setString:[NSString stringWithFormat:@"%@", self.codeAddressStr]];
        
        NSLog(@"已经成功复制%@", pasteboard.string);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, StatusbarHeight+44+GZDeviceHeight/15+GZDeviceWidth*2/5+GZDeviceHeight/50+30+5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            theLabel.alpha=0.8f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"成功复制地址";
            [self.view addSubview:theLabel];
            
            //设置动画
            CATransition *transion=[CATransition animation];
            transion.type=@"push";//动画方式
            transion.subtype=@"fromRight";//设置动画从哪个方向开始
            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
            //不占用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                [theLabel removeFromSuperview];
                
                self.copytheaddressButton.enabled=YES;
                self.copytheaddressButton.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
                
            });//这句话的意思是1.5秒后，把label移出视图
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, StatusbarHeight+44+GZDeviceHeight/15+GZDeviceWidth*2/5+GZDeviceHeight/50+30+5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            theLabel.alpha=0.8f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"复制地址失败";
            [self.view addSubview:theLabel];
            
            //设置动画
            CATransition *transion=[CATransition animation];
            transion.type=@"push";//动画方式
            transion.subtype=@"fromRight";//设置动画从哪个方向开始
            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
            //不占用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                [theLabel removeFromSuperview];
                
                self.copytheaddressButton.enabled=YES;
                self.copytheaddressButton.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
                
            });//这句话的意思是1.5秒后，把label移出视图
        });
    }
    
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

-(void)backMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
