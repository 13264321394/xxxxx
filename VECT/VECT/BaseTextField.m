//
//  BaseTextField.m
//  VECT
//
//  Created by 方墨 on 2018/7/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

//UITextField 禁用复制粘贴功能
//重载方法，控制弹出选项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//粘贴
    {
        return NO;
    } else if (action == @selector(copy:))//复制
    {
        return NO;
    } else if (action == @selector(select:))//选择
    {
        return NO;
    } else {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
