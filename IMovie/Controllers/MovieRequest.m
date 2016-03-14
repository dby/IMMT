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
        
        switch (self.requestType) {
            case MovieRequestTypeOnShowing:
                
                break;
                
            case MovieRequestTypeToShow:
                break;
                
            case MovieRequestTypeBestReview:
                
                break;
                
            case MovieRequestTypeLatestReview:
                
                break;
                
            default:
                break;
        }
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
            break;
        case MovieRequestTypeLatestReview:
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
            
            break;
            
        case MovieRequestTypeLatestReview:
            
            break;
        case MovieRequestTypeDetailMovieInfo:
            
            return self.para;
            
            break;
            
        default:
            break;
    }
    return NULL;
}

@end
