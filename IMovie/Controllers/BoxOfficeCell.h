//
//  BoxOfficeCell.h
//  IMovie
//
//  Created by sys on 16/2/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxOfficeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *MoreBtn;
@property (nonatomic, strong) UIImageView *imageLeft;
@property (nonatomic, strong) UIImageView *imageCenter;
@property (nonatomic, strong) UIImageView *imageRight;
@property (nonatomic, strong) UILabel *nameLeftLabel;
@property (nonatomic, strong) UILabel *nameCenterLabel;
@property (nonatomic, strong) UILabel *nameRightLabel;
@property (nonatomic, strong) UILabel *boxOfficeLeftLabel;
@property (nonatomic, strong) UILabel *boxOfficeCenterLabel;
@property (nonatomic, strong) UILabel *boxOfficeRightLabel;

@end
