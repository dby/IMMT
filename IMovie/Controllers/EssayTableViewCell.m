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
    _content.lineBreakMode = NSLineBreakByWordWrapping;
    _content.numberOfLines = 0;
    
    _vote.font = [UIFont systemFontOfSize:12];
    _time.font = [UIFont systemFontOfSize:12];
    
    _img.layer.masksToBounds = YES;
    _img.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
