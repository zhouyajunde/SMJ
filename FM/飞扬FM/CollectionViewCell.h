//
//  CollectionViewCell.h
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  musicModel;

@interface CollectionViewCell : UICollectionViewCell{
    
    NSMutableDictionary *dic;
    NSDate *currenttime;
}

@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UIImageView *bkimgView;
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,strong)UIButton *btn;
@property (nonatomic, strong) musicModel *product;


- (void)configCell:(NSDictionary *)item;
@end
