//
//  DetailMITableViewCell.m
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "DetailMITableViewCell.h"

@implementation DetailMITableViewCell

- (void)awakeFromNib {
    // Initialization code
    _name.font  = [UIFont systemFontOfSize:15];
    _type.font  = [UIFont systemFontOfSize:12];
    _director_release.font = [UIFont systemFontOfSize:12];
    
    _intro.font = [UIFont systemFontOfSize:12];
    _intro.lineBreakMode = NSLineBreakByWordWrapping;
    _intro.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
