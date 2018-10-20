//
//  metionmoneyTableViewCell.m
//  VECT
//
//  Created by 方墨 on 2018/7/7.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "metionmoneyTableViewCell.h"

@implementation metionmoneyTableViewCell

//重写初始化方法:将控件添加到单元格上,如果将子视图控件添加到cell上 借助contenView视图,这样的话cell上子视图会随着cell的变化而变化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //NSLog(@"cell宽度%f cell高度%f", self.bounds.size.width,self.bounds.size.height);
        
        float h=(60.0+GZDeviceHeight/12)-2*8;
        
        UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(8, 5, GZDeviceWidth-2*8, (60.0+GZDeviceHeight/12)-2*5)];
        myView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:myView];
        //设置圆角边框
        myView.layer.cornerRadius = 5.f;
        myView.layer.masksToBounds = YES;
        //设置边框及边框颜色
        myView.layer.borderWidth = 0.5f;
        myView.layer.borderColor =[[UIColor lightGrayColor] CGColor];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth-2*8, (60.0+GZDeviceHeight/12)-2*5)];
        imageView.image=[UIImage imageNamed:@"WechatIMGd3.png"];
        [myView addSubview:imageView];
        imageView.layer.cornerRadius = 5.f;
        imageView.layer.masksToBounds = YES;
        //设置边框及边框颜色
        imageView.layer.borderWidth = 0.5f;
        
        self.labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/13, 10, GZDeviceWidth*0.81, h*0.4)];
        self.labelAddress.textColor = [UIColor blackColor];
        //self.labelAddress.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.labelAddress];
        
        
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/13, 10+h*0.4, GZDeviceWidth*0.81, (0.6*h-10)/2)];
        self.labelTime.textColor = [UIColor blackColor];
        //self.labelTime.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.labelTime];
        
        self.labelNextAddress = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/13, 10+h*0.4+(0.6*h-10)/2, GZDeviceWidth*0.8, (0.6*h-10)/2)];
        //self.labelNextAddress.backgroundColor=[UIColor blueColor];
        self.labelNextAddress.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.labelNextAddress];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
