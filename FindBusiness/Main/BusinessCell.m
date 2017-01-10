//
//  BusinessCell.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/9.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)bind:(NSDictionary*)dict;
{
    self.name.text = dict[@"name"];
    self.UMCode.text = dict[@"code"];
    self.time.text = dict[@"date"];
    self.state.text = dict[@"state"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
