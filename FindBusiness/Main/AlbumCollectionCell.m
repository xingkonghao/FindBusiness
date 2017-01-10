//
//  AlbumCollectionCell.m
//  CheDai
//
//  Created by 星空浩 on 16/8/4.
//  Copyright © 2016年 DFYG_YF3. All rights reserved.
//

#import "AlbumCollectionCell.h"

@implementation AlbumCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectAction:(UIButton*)sender {
    sender.selected = !sender.selected;
   
}
@end
