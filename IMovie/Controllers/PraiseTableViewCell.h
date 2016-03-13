//
//  PraiseTableViewCell.h
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
