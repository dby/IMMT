//
//  EssayTableViewCell.h
//  IMovie
//
//  Created by sys on 16/3/16.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EssayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *vote;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
