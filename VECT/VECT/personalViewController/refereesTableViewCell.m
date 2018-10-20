//
//  refereesTableViewCell.m
//  VECT
//
//  Created by 方墨 on 2018/7/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "refereesTableViewCell.h"

@implementation refereesTableViewCell

//重写初始化方法:将控件添加到单元格上,如果将子视图控件添加到cell上 借助contenView视图,这样的话cell上子视图会随着cell的变化而变化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //NSLog(@"cell宽度%f cell高度%f", self.bounds.size.width,self.bounds.size.height);
        
        UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(5, 2, GZDeviceWidth-2*5, 60-2*2)];
        myView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:myView];
        //设置圆角边框
        myView.layer.cornerRadius = 5;
        myView.layer.masksToBounds = YES;
        //设置边框及边框颜色
        myView.layer.borderWidth = 0.5;
        myView.layer.borderColor =[ [UIColor grayColor] CGColor];
        
        
        self.labelAccount = [[UILabel alloc] initWithFrame:CGRectMake(10, (60-30)/2, GZDeviceWidth/2.5, 30)];
        self.labelAccount.textColor = [UIColor blackColor];
        //self.labelAccount.backgroundColor=[UIColor blackColor];
        //self.labelAccount.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelAccount];
        
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2-25, (60-30)/2, 100, 30)];
        self.labelName.textColor = [UIColor blackColor];
        //self.labelName.backgroundColor=[UIColor yellowColor];
        //self.labelName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelName];
        
        self.labelIdentitystatus = [[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth-60-GZDeviceWidth/10, (60-30)/2, 100, 30)];
        //self.labelIdentitystatus.textColor = [UIColor greenColor];
        //self.labelIdentitystatus.backgroundColor=[UIColor blueColor];
        //self.labelIdentitystatus.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelIdentitystatus];
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
