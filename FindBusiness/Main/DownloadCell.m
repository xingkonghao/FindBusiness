//
//  DownloadCell.m
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import "DownloadCell.h"

@interface DownloadCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentW;

@end

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)bind:(NSDictionary*)model;
{
    if (!STR_IS_NIL(model[@"url"])) {
        self.fileName.text = [NSString md5:model[@"url"]];
    }
    self.bytes.text = [NSString stringWithFormat:@"%lldKB/%lldKB",[model[@"completedUnitCount"] longLongValue]/1024,[model[@"totalUnitCount"] longLongValue]/1024];
    self.remindLab.text =  [model[@"completedUnitCount"] longLongValue]== [model[@"totalUnitCount"] longLongValue]?@"下载完成":@"下载中";
    CGFloat totalW = SCREEN_WIDTH - 65;
    self.currentW.constant = totalW * [model[@"completedUnitCount"] longLongValue]/[model[@"totalUnitCount"] longLongValue];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
