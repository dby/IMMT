//
//  BoxOfficeCell.m
//  IMovie
//
//  Created by sys on 16/2/28.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "BoxOfficeCell.h"

@implementation BoxOfficeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}


- (void)initSubviews
{
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    
    self.nameLeftLabel = [UILabel new];
    self.nameLeftLabel.numberOfLines = 0;
    self.nameLeftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLeftLabel.font = [UIFont systemFontOfSize:10];
    self.nameLeftLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameLeftLabel];
    
    self.nameCenterLabel = [UILabel new];
    self.nameCenterLabel.numberOfLines = 0;
    self.nameCenterLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameCenterLabel.font = [UIFont systemFontOfSize:10];
    self.nameCenterLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameCenterLabel];
    
    self.nameRightLabel = [UILabel new];
    self.nameRightLabel.numberOfLines = 0;
    self.nameRightLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameRightLabel.font = [UIFont systemFontOfSize:10];
    self.nameRightLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.nameRightLabel];
    
    self.boxOfficeLeftLabel = [UILabel new];
    self.boxOfficeLeftLabel.numberOfLines = 0;
    self.boxOfficeLeftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.boxOfficeLeftLabel.font = [UIFont systemFontOfSize:13];
    self.boxOfficeLeftLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.boxOfficeLeftLabel];
    
    self.boxOfficeCenterLabel = [UILabel new];
    self.boxOfficeCenterLabel.numberOfLines = 0;
    self.boxOfficeCenterLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.boxOfficeCenterLabel.font = [UIFont systemFontOfSize:13];
    self.boxOfficeCenterLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.boxOfficeCenterLabel];
    
    self.boxOfficeRightLabel = [UILabel new];
    self.boxOfficeRightLabel.numberOfLines = 0;
    self.boxOfficeRightLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.boxOfficeRightLabel.font = [UIFont systemFontOfSize:13];
    self.boxOfficeRightLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.boxOfficeRightLabel];
    
    self.MoreBtn = [UIButton new];
    self.MoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.MoreBtn.titleLabel.textColor = [UIColor grayColor];
    self.MoreBtn.titleLabel.text = @"更多";
    [self.contentView addSubview:self.MoreBtn];
    
    self.imageLeft = [UIImageView new];
    [self.contentView addSubview:self.imageLeft];
    
    self.imageCenter = [UIImageView new];
    [self.contentView addSubview:self.imageCenter];
    
    self.imageRight = [UIImageView new];
    [self.contentView addSubview:self.imageRight];
}

- (void)setLayout
{
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel, _nameLeftLabel, _nameCenterLabel, _nameRightLabel, _imageLeft, _imageCenter, _imageRight, _boxOfficeLeftLabel, _boxOfficeCenterLabel, _boxOfficeRightLabel, _MoreBtn);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-[_MoreBtn(30)]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_imageLeft(_imageCenter)]-[_imageCenter(_imageRight)]-[_imageRight]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nameLeftLabel(_nameCenterLabel)]-[_nameCenterLabel(_nameRightLabel)]-[_nameRightLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_boxOfficeLeftLabel(_boxOfficeCenterLabel)]-[_boxOfficeCenterLabel(_boxOfficeRightLabel)]-[_boxOfficeRightLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_titleLabel]-5-[_imageLeft]-5-[_nameLeftLabel]-5-[_boxOfficeLeftLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_titleLabel]-5-[_imageCenter]-5-[_nameCenterLabel]-5-[_boxOfficeCenterLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_titleLabel]-5-[_imageRight]-5-[_nameRightLabel]-5-[_boxOfficeRightLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageRight
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageRight
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.3
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageCenter
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageCenter
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.3
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageLeft
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageLeft
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.3
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageCenter
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
}

@end
