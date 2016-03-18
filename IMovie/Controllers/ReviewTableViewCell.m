//
//  ReviewTableViewCell.m
//  IMovie
//
//  Created by sys on 16/3/18.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "ReviewTableViewCell.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _portrait.layer.masksToBounds = YES;
    _portrait.layer.cornerRadius = 20;
    
    _title.font = [UIFont systemFontOfSize:16];
    _title.numberOfLines = 0;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    
    _author.font = [UIFont systemFontOfSize:12];
    
    _content.font = [UIFont systemFontOfSize:12];
    _content.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
