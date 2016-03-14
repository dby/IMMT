//
//  DetailMITableViewCell.h
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *director_release;
@property (weak, nonatomic) IBOutlet UILabel *intro;

@end
