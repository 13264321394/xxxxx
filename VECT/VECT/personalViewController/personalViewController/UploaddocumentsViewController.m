//
//  UploaddocumentsViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/11.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "UploaddocumentsViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"

@interface UploaddocumentsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController
@property(nonatomic,strong)UIImageView *iv;
@property(nonatomic,copy)NSString *imagefullpath1;
@property(nonatomic,copy)NSString *imagefullpath2;
@property(nonatomic,copy)NSString *imagefullpath3;
@property(nonatomic,copy)UIActionSheet *sheet;
@property(nonatomic,copy)UILabel *nameLabel2;
@property(nonatomic,copy)UILabel *sexLabel2;
@property(nonatomic,copy)UILabel *phoneLabel2;

@end

@implementation UploaddocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"上传";
    realnameLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UIButton *savebutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*4/5, StatusbarHeight+7, 50, 30)];
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    savebutton.titleLabel.font=[UIFont systemFontOfSize:13.f];
    //backbutton.backgroundColor=[UIColor blueColor];
    //backbutton.titleLabel.textColor=[UIColor blackColor];
    [savebutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(saveMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebutton];
    
    UIView *grayView=[[UIView alloc] init];
    grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 10));
    }];
    
    UIButton *positiveButton=[[UIButton alloc] init];
    positiveButton.backgroundColor=[UIColor whiteColor];
    [positiveButton addTarget:self action:@selector(positiveMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positiveButton];
    [positiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.text=@"证件正面";
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _nameLabel2=[[UILabel alloc] init];
    _nameLabel2.text=@"";
    _nameLabel2.textColor=[UIColor greenColor];
    [self.view addSubview:_nameLabel2];
    [_nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(GZDeviceWidth-10-GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView1=[[UIView alloc] init];
    grayView1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UIButton *onbackButton=[[UIButton alloc] init];
    onbackButton.backgroundColor=[UIColor whiteColor];
    [onbackButton addTarget:self action:@selector(onbackMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onbackButton];
    [onbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UILabel *sexLabel2=[[UILabel alloc] init];
    sexLabel2.text=@"证件背面";
    [self.view addSubview:sexLabel2];
    [sexLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    _sexLabel2=[[UILabel alloc] init];
    _sexLabel2.text=@"";
    _sexLabel2.textColor=[UIColor greenColor];
    [self.view addSubview:_sexLabel2];
    [_sexLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth-10-GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView2=[[UIView alloc] init];
    grayView2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UIButton *handButton=[[UIButton alloc] init];
    handButton.backgroundColor=[UIColor whiteColor];
    [handButton addTarget:self action:@selector(handMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handButton];
    [handButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UILabel *phoneLabel=[[UILabel alloc] init];
    phoneLabel.text=@"手持证件照";
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/3, 20+GZDeviceHeight/20));
    }];
    _phoneLabel2=[[UILabel alloc] init];
    _phoneLabel2.text=@"";
    _phoneLabel2.textColor=[UIColor greenColor];
    [self.view addSubview:_phoneLabel2];
    [_phoneLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth-10-GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView6=[[UIView alloc] init];
    grayView6.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView6];
    [grayView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20)));
    }];
    
    //_iv=[[UIImageView alloc] initWithFrame:CGRectMake(10, GZDeviceHeight/2, GZDeviceWidth/2, GZDeviceWidth/2)];
    //[self.view addSubview:_iv];
    
    // Do any additional setup after loading the view.
}

-(void)positiveMethod
{
    NSLog(@"点击了证件正面按钮");
    
    //自定义消息框
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
        _sheet.tag = 2550;
        [_sheet showInView:self.view];
    }
}

-(void)onbackMethod
{
    NSLog(@"点击了证件被面按钮");
    
    //自定义消息框
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
        _sheet.tag = 2551;
        [_sheet showInView:self.view];
    }
}

-(void)handMethod
{
    NSLog(@"点击了手持证件照按钮");
    
    //自定义消息框
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
        _sheet.tag = 2552;
        [_sheet showInView:self.view];
    }
}

//消息框代理实现
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2550) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                return;
            }else if (buttonIndex == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if (actionSheet.tag == 2551) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;// 是否有图片选取框
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                return;
            }else if (buttonIndex == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if (actionSheet.tag == 2552) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (buttonIndex == 0) {
                return;
            }else if (buttonIndex == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

//实现图片选择器代理-上传图片的网络请求也是在这个方法里面进行
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍

    [self sendImageWithImage:image];
    
    //_iv.image=image;

    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)sendImageWithImage:(UIImage *)image
{
    NSLog(@"图片有没有：%@", image);
    
    CGSize imagesize = image.size;
    imagesize.height =600;
    imagesize.width =600;
    image = [self imageWithImage:image scaledToSize:imagesize];
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    //NSData *imagedata=UIImagePNGRepresentation(image);
    
    UIView *darkview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight)];
    darkview.backgroundColor=[UIColor blackColor];
    darkview.alpha=0.6f;
    [self.view addSubview:darkview];
    
    UIActivityIndicatorView *tableFooterActivityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
    tableFooterActivityIndicator.color=[UIColor lightGrayColor];
    [self.view addSubview:tableFooterActivityIndicator];
    [tableFooterActivityIndicator startAnimating];
    self.view.userInteractionEnabled=NO;
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",@"text/plain", nil];//如果报接受类型不一致请替换一致text/html或别的
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:mytoken forKey:@"token"];
    [parameters setValue:@"51" forKey:@"id"];
    [parameters setValue:imagedata forKey:@"file"];
    NSLog(@"字典的值：%@", parameters);
    //[portUrl stringByAppendingString:@"/rest/imgUpload/upload"]
    //@"0.tcp.ngrok.io:12436"
    //NSString *str1=@"0.tcp.ngrok.io:12436";
    [manager POST:[portUrl stringByAppendingString:@"/rest/imgUpload/upload"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传文件参数
        NSLog(@"我需要的相片data：%@", imagedata);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSLog(@"我需要的fileName：%@", fileName);
        [formData appendPartWithFileData:imagedata name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableFooterActivityIndicator stopAnimating];//菊花停止
            [tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏菊花
            self.view.userInteractionEnabled=YES;
            [darkview removeFromSuperview];
        });
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        NSLog(@"返回的说明desc：%@", [responseObject objectForKey:@"desc"]);
        NSString *theimagepath=[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"desc"]];
        
        if (self.sheet.tag==2550) {
            self.imagefullpath1=[NSString stringWithFormat:@"%@", theimagepath];
            self.nameLabel2.text=@"上传成功";
            NSLog(@"第一张图片上传成功");
        } else if (self.sheet.tag==2551) {
            self.imagefullpath2=[NSString stringWithFormat:@"%@", theimagepath];
            self.sexLabel2.text=@"上传成功";
            NSLog(@"第二张图片上传成功");
        } else if (self.sheet.tag==2552) {
            self.imagefullpath3=[NSString stringWithFormat:@"%@", theimagepath];
            self.phoneLabel2.text=@"上传成功";
            NSLog(@"第三张图片上传成功");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableFooterActivityIndicator stopAnimating];//菊花停止
            [tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏菊花
            self.view.userInteractionEnabled=YES;
            
        });
        
        if (self.sheet.tag==2550) {
            self.nameLabel2.text=@"上传失败";
            NSLog(@"第一张图片上传失败");
        } else if (self.sheet.tag==2551) {
            self.sexLabel2.text=@"上传失败";
            NSLog(@"第二张图片上传失败");
        } else if (self.sheet.tag==2552) {
            self.phoneLabel2.text=@"上传失败";
            NSLog(@"第三张图片上传失败");
        }
    }];
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)backMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveMethod
{
    NSLog(@"路径1==%@", self.imagefullpath1);
    NSLog(@"路径2==%@", self.imagefullpath2);
    NSLog(@"路径3==%@", self.imagefullpath3);
    NSLog(@"点击了保存按钮");
    
    if ((self.imagefullpath1.length!=0) && (self.imagefullpath2.length!=0) && (self.imagefullpath3.length!=0)) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.imagefullpath1 forKey:@"imagepath1"];
        [userDefaults setObject:self.imagefullpath2 forKey:@"imagepath2"];
        [userDefaults setObject:self.imagefullpath3 forKey:@"imagepath3"];
        
        NSLog(@"路径1=%@  路径2=%@ 路径3=%@", [userDefaults stringForKey:@"imagepath1"], [userDefaults stringForKey:@"imagepath2"], [userDefaults stringForKey:@"imagepath3"]);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择正面，反面，手执证件照完全" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
