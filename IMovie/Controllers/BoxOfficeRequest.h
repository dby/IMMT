//
//  BoxOfficeRequest.h
//  IMovie
//
//  Created by sys on 16/2/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSUInteger, BoxOfficeType) {
    BoxOfficeTypeHour       = 1,
    BoxOfficeTypeDay        = 2,
    BoxOfficeTypeWeekend    = 3,
    BoxOfficeTypeWeek       = 4,
    BoxOfficeTypeMonth      = 5,
    BoxOfficeTypeYear       = 6,
    BoxOfficeTypeGlobal     = 7,
};

@interface BoxOfficeRequest : YTKRequest

- (instancetype)initWithType:(BoxOfficeType)type withPara:(NSDictionary *)para;

@end
