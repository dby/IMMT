//
//  BoxOfficeRequest.m
//  IMovie
//
//  Created by sys on 16/2/27.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "BoxOfficeRequest.h"
#import "IMTAPI.h"
#import "YTKBatchRequest.h"

@interface BoxOfficeRequest()

@property (nonatomic) BoxOfficeType boxOfficeType;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *sdate;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *weekId;

@end

@implementation BoxOfficeRequest

-(instancetype)initWithType:(BoxOfficeType)type withPara:(NSDictionary *)para
{
    self = [super init];
    if (self) {
        self.boxOfficeType = type;
        
        switch (self.boxOfficeType) {
            case BoxOfficeTypeHour:
                
                break;
                
            case BoxOfficeTypeDay:
                _num = para[@"num"];
                break;
                
            case BoxOfficeTypeWeek:
                
                break;
                
            case BoxOfficeTypeWeekend:
                
                break;
                
            case BoxOfficeTypeMonth:
                _sdate = para[@"sdate"];
                break;
                
            case BoxOfficeTypeYear:
                _year = para[@"year"];
                break;
                
            case BoxOfficeTypeGlobal:
                _weekId = para[@"weekId"];
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
    switch (self.boxOfficeType)
    {
        case BoxOfficeTypeHour:
            url = @"/boxofficehour/";
            break;
        case BoxOfficeTypeDay:
            url = @"/boxofficeday/";
            break;
        case BoxOfficeTypeWeek:
            url = @"/boxofficeweek/";
            break;
        case BoxOfficeTypeMonth:
            url = @"/boxofficemonth/";
            break;
        case BoxOfficeTypeWeekend:
            url = @"/boxofficeweekend/";
            break;
        case BoxOfficeTypeYear:
            url = @"/boxofficeyear/";
            break;
        case BoxOfficeTypeGlobal:
            url = @"/boxofficeglobal/";
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
    switch (self.boxOfficeType) {
        
        case BoxOfficeTypeHour:
            
            break;
                
        case BoxOfficeTypeDay:
            return @{@"num": _num};
            break;
                
        case BoxOfficeTypeWeek:
                
            break;
                
        case BoxOfficeTypeWeekend:
                
            break;
                
        case BoxOfficeTypeMonth:
            return @{@"sdate": _sdate};
            break;
                
        case BoxOfficeTypeYear:
            return @{@"year": _year};
            break;
                
        case BoxOfficeTypeGlobal:
            return @{@"weekId": _weekId};
            break;
                
        default:
            break;
        }
    return NULL;
}

@end