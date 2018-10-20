//
//  thedetailTableViewCell.m
//  VECT
//
//  Created by 方墨 on 2018/7/11.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "thedetailTableViewCell.h"

@implementation thedetailTableViewCell

//重写初始化方法:将控件添加到单元格上,如果将子视图控件添加到cell上 借助contenView视图,这样的话cell上子视图会随着cell的变化而变化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //NSLog(@"cell宽度%f cell高度%f", self.bounds.size.width,self.bounds.size.height);
        
        float h=70;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (h-h/4.5)/2, h/4.5, h/4.5*46/33)];
        //imageView.image=[UIImage imageNamed:@"VECTlogol3.png"];
        [self.contentView addSubview:imageView];
        self.iconImageView=imageView;
        
        
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(15+h/3+15, 5, GZDeviceWidth/3, 30)];
        //self.label1.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.label1];
        
        
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(15+h/3+15, 5+30, GZDeviceWidth/3, 30)];
        //self.label2.backgroundColor=[UIColor orangeColor];
        [self.contentView addSubview:self.label2];
        
        
        self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth-GZDeviceWidth/2.3-15, 5, GZDeviceWidth/2.3, 35)];
        //self.label3.backgroundColor=[UIColor blueColor];
        self.label3.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.label3];
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
