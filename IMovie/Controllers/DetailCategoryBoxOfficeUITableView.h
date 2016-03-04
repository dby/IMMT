//
//  DetailCategoryBoxOfficeUITableView.h
//  IMovie
//
//  Created by sys on 16/3/3.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxOfficeRequest.h"

@interface DetailCategoryBoxOfficeUITableView : UITableViewController

@property (nonatomic) BoxOfficeType type;
@property (nonatomic, strong) NSDictionary *para;

@end
