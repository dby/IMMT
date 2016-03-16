//
//  MovieRequest.m
//  IMovie
//
//  Created by sys on 16/3/5.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "MovieRequest.h"

@interface MovieRequest()
{
    
}

@property (assign) MovieRequestType requestType;
@property (nonatomic, strong) NSDictionary *para;

@end

@implementation MovieRequest

-(instancetype)initWithType:(MovieRequestType)type withPara:(NSDictionary *)para
{
    self = [super init];
    if (self) {
        self.requestType = type;
        self.para = para;
    }
    
    return self;
}

-(NSString *)requestUrl
{
    NSString *url = @"";
    switch (self.requestType)
    {
        case MovieRequestTypeOnShowing:
            url = @"/onshowingfilms/";
            break;
        case MovieRequestTypeNewMovieRankingList:
            url = @"/rankinglist/";
            break;
        case MovieRequestTypeToShow:
            break;
        case MovieRequestTypeBestReview:
            url = @"/review/";
            break;
        case MovieRequestTypeLatestReview:
            url = @"/review/";
            break;
        case MovieRequestTypeEssays:
            url = @"/essay/";
            break;
        case MovieRequestTypeDetailMovieInfo:
            url = @"/film/";
            break;
            
        default:
            url = @"";
            break;
    };
    return url;
}

-(YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

-(id)requestArgument
{
    switch (self.requestType) {
            
        case MovieRequestTypeOnShowing:
            
            break;
            
        case MovieRequestTypeToShow:
            break;
            
        case MovieRequestTypeBestReview:
            return self.para;
            break;
            
        case MovieRequestTypeLatestReview:
            break;
        
        case MovieRequestTypeDetailMovieInfo:
            return self.para;
            break;
            
        case MovieRequestTypeEssays:
            return self.para;
            break;
            
        default:
            break;
    }
    return NULL;
}

@end
