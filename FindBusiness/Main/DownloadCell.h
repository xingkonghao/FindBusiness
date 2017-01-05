//
//  DownloadCell.h
//  FindBusiness
//
//  Created by 星空浩 on 2017/1/4.
//  Copyright © 2017年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UIView *rate;
@property (weak, nonatomic) IBOutlet UILabel *bytes;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;
-(void)bind:(NSDictionary*)model;
@end
