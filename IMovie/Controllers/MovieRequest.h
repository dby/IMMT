//
//  MovieRequest.h
//  IMovie
//
//  Created by sys on 16/3/5.
//  Copyright © 2016年 sys. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSUInteger, MovieRequestType) {
    MovieRequestTypeOnShowing           = 1,
    MovieRequestTypeToShow              = 2,
    MovieRequestTypeNewMovieRankingList = 3,
    MovieRequestTypeBestReview          = 4,
    MovieRequestTypeLatestReview        = 5,
    MovieRequestTypeDetailMovieInfo     = 6,
};

@interface MovieRequest : YTKRequest

-(instancetype)initWithType:(MovieRequestType)type withPara:(NSDictionary *)para;

@end
