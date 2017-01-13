//
//  EmptyView.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "EmptyView.h"


@implementation EmptyView


-(UILabel*)reminderLab
{
    if (!_reminderLab) {
        _reminderLab = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0,self.frame.size.height/2.0-15, 100, 30)];
        _reminderLab.textAlignment = NSTextAlignmentCenter;
        _reminderLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_reminderLab];
        [self remiderImage];
    }
    return _reminderLab;
}
-(UIImageView*)remiderImage
{
    if (!_remiderImage) {
        _remiderImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-50, self.frame.size.height/2.0-25, 50, 50)];
        
        _remiderImage.image = [UIImage imageNamed:@"img_impty_55"];
        [self addSubview:_remiderImage];
        
    }
    return _remiderImage;
}
-(void)setRemiderInfo:(NSString *)remiderInfo
{
    if (remiderInfo) {
       CGRect rect = [remiderInfo boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:0 attributes:nil context:nil];
        self.reminderLab.text = remiderInfo;
        self.reminderLab.frame = CGRectMake(self.frame.size.width/2.0 - rect.size.width/2.0,self.frame.size.height/2.0-10,rect.size.width+30, 20);
        self.remiderImage.frame = CGRectMake(CGRectGetMinX(self.reminderLab.frame)-50,self.frame.size.height/2.0 - 25, 50, 50);
    }
}
@end
