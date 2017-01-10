//
//  AlbumCollectionCell.h
//  CheDai
//
//  Created by 星空浩 on 16/8/4.
//  Copyright © 2016年 DFYG_YF3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumCollectionCellDelegate <NSObject>

- (void)selectState:(BOOL)state index:(NSIndexPath*)indexPath;

@end

@interface AlbumCollectionCell : UICollectionViewCell
@property (nonatomic,weak)id <AlbumCollectionCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong)NSIndexPath *indexPath;
- (IBAction)selectAction:(id)sender;

@end
