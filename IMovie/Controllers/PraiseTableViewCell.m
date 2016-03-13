//
//  PraiseTableViewCell.m
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "PraiseTableViewCell.h"

@implementation PraiseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _cover.contentMode = UIViewContentModeScaleAspectFit;
    _detail.numberOfLines = 5;
    _detail.font = [UIFont systemFontOfSize:13];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
