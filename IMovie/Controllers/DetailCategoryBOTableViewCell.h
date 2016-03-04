//
//  DetailCategoryBOTableViewCell.h
//  IMovie
//
//  Created by sys on 16/3/4.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCategoryBOTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;              // 电影名称
@property (nonatomic, strong) UIImageView *image;               // 电影海报
@property (nonatomic, strong) UILabel *directorLabel;           // 导演
@property (nonatomic, strong) UILabel *boxOfficeLabel;          // 当天票房
@property (nonatomic, strong) UILabel *sumBoxOfficeLabel;       // 总票房
@property (nonatomic, strong) UILabel *womIndexboxLabel;        // 口碑指数

@end
