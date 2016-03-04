//
//  DetailCategoryBOTableViewCell.m
//  IMovie
//
//  Created by sys on 16/3/4.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "DetailCategoryBOTableViewCell.h"

@implementation DetailCategoryBOTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.directorLabel = [UILabel new];
    self.directorLabel.numberOfLines = 0;
    self.directorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.directorLabel.font = [UIFont systemFontOfSize:10];
    self.directorLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.directorLabel];
    
    self.boxOfficeLabel = [UILabel new];
    self.boxOfficeLabel.numberOfLines = 0;
    self.boxOfficeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.boxOfficeLabel.font = [UIFont systemFontOfSize:10];
    self.boxOfficeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.boxOfficeLabel];
    
    self.sumBoxOfficeLabel = [UILabel new];
    self.sumBoxOfficeLabel.numberOfLines = 0;
    self.sumBoxOfficeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.sumBoxOfficeLabel.font = [UIFont systemFontOfSize:10];
    self.sumBoxOfficeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.sumBoxOfficeLabel];
    
    self.womIndexboxLabel = [UILabel new];
    self.womIndexboxLabel.numberOfLines = 0;
    self.womIndexboxLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.womIndexboxLabel.font = [UIFont systemFontOfSize:13];
    self.womIndexboxLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.womIndexboxLabel];
    
    self.image = [UIImageView new];
    [self.contentView addSubview:self.image];
}

- (void)setLayout
{
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel, _directorLabel, _boxOfficeLabel, _sumBoxOfficeLabel, _womIndexboxLabel, _image);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_image(70)]-10-[_titleLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_image]-10-[_directorLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_image]-10-[_womIndexboxLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_image]-10-[_boxOfficeLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_image]-10-[_sumBoxOfficeLabel]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_image]-|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-[_directorLabel]-[_womIndexboxLabel]-[_boxOfficeLabel]-[_sumBoxOfficeLabel]|"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
}

@end
