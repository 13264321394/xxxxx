//
//  metionmoneyTableViewCell.h
//  VECT
//
//  Created by 方墨 on 2018/7/7.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface metionmoneyTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *labelAddress;//大地址
@property (nonatomic, strong) UILabel *labelTime; //时间
@property (nonatomic, strong) UILabel *labelNextAddress; //小地址

@end
