//
//  BoxOfficeViewController.m
//  IMovie
//
//  Created by sys on 16/2/25.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "BoxOfficeViewController.h"

#import "BoxOfficeRequest.h"
#import <MBProgressHUD.h>
#import "YTKBatchRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "BoxOfficeCell.h"
#import "IMTAPI.h"

static NSString *kBoxOfficeCellID = @"BoxOfficeCellID";

@interface BoxOfficeViewController ()

@property(nonatomic, strong) NSMutableArray *BoxOfficeArray;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, strong) NSDate *lastRefreshTime;
@property (nonatomic, copy) NSString *kLastRefreshTime;

@end

@implementation BoxOfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[BoxOfficeCell class] forCellReuseIdentifier:kBoxOfficeCellID];
    [self fetchObjects];
}

#pragma mark - function

- (void)fetchObjects
{
    BoxOfficeRequest *hourRequest       = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeHour      withPara:NULL];
    BoxOfficeRequest *dayRequest        = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeDay       withPara:@{@"num":@"0"}];
    BoxOfficeRequest *weekendRequest    = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeWeekend   withPara:NULL];
    //BoxOfficeRequest *weekRequest     = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeWeek      withPara:NULL];
    BoxOfficeRequest *monthRequest      = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeMonth     withPara:@{@"sdate":@"2016-1-11"}];
    BoxOfficeRequest *yearRequest       = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeYear      withPara:@{@"year":@"2016"}];
    BoxOfficeRequest *globalRequest     = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeGlobal    withPara:@{@"weekId":@"3500"}];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[/*hourRequest,*/ dayRequest/*, weekendRequest, weekendRequest, monthRequest, yearRequest, globalRequest*/]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        NSLog(@"succeed");
        NSArray *requests = batchRequest.requestArray;
        self.BoxOfficeArray = [requests copy];
        
        YTKBaseRequest *ytkb    = (YTKBaseRequest *)self.BoxOfficeArray[0];
        NSLog(@"info: %@", ytkb.responseString);
        
        [self.tableView reloadData];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
        [self fetchObjects];
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:kBoxOfficeCellID forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    NSLog(@"index: %ld", (long)indexPath.row);
    cell.backgroundColor = [UIColor whiteColor];
    
    YTKBaseRequest *ytkb    = (YTKBaseRequest *)self.BoxOfficeArray[index];
    NSDictionary *element   = [self dictionaryWithJsonString:ytkb.responseString];
    [cell.titleLabel setText: @"日榜单"];
    
    
    if (element != NULL && indexPath.row == 0 && [element[@"data1"] count] >= 3) {
        
        [cell.nameLeftLabel     setText: element[@"data1"][0][@"MovieName"]];
        [cell.nameCenterLabel   setText: element[@"data1"][1][@"MovieName"]];
        [cell.nameRightLabel    setText: element[@"data1"][2][@"MovieName"]];
        
        [cell.boxOfficeLeftLabel    setText: element[@"data1"][0][@"sumBoxOffice"]];
        [cell.boxOfficeCenterLabel  setText: element[@"data1"][1][@"sumBoxOffice"]];
        [cell.boxOfficeRightLabel   setText: element[@"data1"][2][@"sumBoxOffice"]];
        
        NSString *imgStrLeft = [ImageSuffix stringByAppendingString:element[@"data1"][0][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrLeft] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        NSString *imgStrCenter = [ImageSuffix stringByAppendingString:element[@"data1"][1][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrCenter] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        NSString *imgStrRight = [ImageSuffix stringByAppendingString:element[@"data1"][2][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrRight] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    OSCNews *news = self.objects[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    [self.label setAttributedText:news.attributedTittle];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    self.label.text = news.body;
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    */
    
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    OSCNews *news = self.objects[indexPath.row];
    if (news.eventURL.absoluteString.length > 0) {
        ActivityDetailsWithBarViewController *activityBVC = [[ActivityDetailsWithBarViewController alloc] initWithActivityID:[news.attachment longLongValue]];
        [self.navigationController pushViewController:activityBVC animated:YES];
    } else if (news.url.absoluteString.length > 0) {
        [self.navigationController handleURL:news.url];
    } else {
        DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithNews:news];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
     */
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
