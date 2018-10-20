//
//  secondTableViewCell.m
//  VECT
//
//  Created by 方墨 on 2018/7/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "secondTableViewCell.h"

@implementation secondTableViewCell

//重写初始化方法:将控件添加到单元格上,如果将子视图控件添加到cell上 借助contenView视图,这样的话cell上子视图会随着cell的变化而变化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //NSLog(@"cell宽度%f cell高度%f", self.bounds.size.width,self.bounds.size.height);
        
        float h=30+GZDeviceHeight/17;
        
        UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(8, 5, GZDeviceWidth-2*8, h-2*5)];
        myView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:myView];
        //设置圆角边框
        myView.layer.cornerRadius = 5.f;
        myView.layer.masksToBounds = YES;
        //设置边框及边框颜色
        myView.layer.borderWidth = 0.5f;
        myView.layer.borderColor =[[UIColor lightGrayColor] CGColor];
        
        
        self.view0 = [[UIView alloc] initWithFrame:CGRectMake(20, (h-h*0.65)/2, h*0.65, h*0.65)];
        //self.view0.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:self.view0];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, h*0.65, h*0.65)];
        //imageView.image=[UIImage imageNamed:@"VECTlogol3.png"];
        [self.view0 addSubview:imageView];
        imageView.layer.cornerRadius = imageView.frame.size.width/2.0;
        imageView.layer.masksToBounds = YES;
        
        
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(h*0.65+GZDeviceWidth/10, (h-35)/2, 70, 35)];
        self.labelName.textColor = [UIColor blackColor];
        //self.labelName.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.labelName];
        
        self.labelAssets = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.4, (h-35)/2, GZDeviceWidth*0.56, 35)];
        //self.labelAssets.backgroundColor=[UIColor blueColor];
        self.labelAssets.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.labelAssets];
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
