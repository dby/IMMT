//
//  EssayTableViewCell.m
//  IMovie
//
//  Created by sys on 16/3/16.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "EssayTableViewCell.h"

@implementation EssayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _content.font = [UIFont systemFontOfSize:12];
    _content.numberOfLines = 5;
    
    _img.layer.cornerRadius = _img.image.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
