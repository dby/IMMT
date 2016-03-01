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
{
    NSArray *keys;
}

@property(nonatomic, strong) NSMutableDictionary *BoxOfficeDic;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, strong) NSDate *lastRefreshTime;
@property (nonatomic, copy) NSString *kLastRefreshTime;

@end

@implementation BoxOfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BoxOfficeDic = [NSMutableDictionary dictionaryWithCapacity:6];
    keys = @[ @"hour", @"day", @"weekend", @"month" ,@"global"];

    
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
    //BoxOfficeRequest *yearRequest       = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeYear      withPara:@{@"year":@"2016"}];
    BoxOfficeRequest *globalRequest     = [[BoxOfficeRequest alloc] initWithType:BoxOfficeTypeGlobal    withPara:@{@"weekId":@"3500"}];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[hourRequest, dayRequest, weekendRequest, monthRequest , globalRequest]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        for (int i = 0; i < 5; i++) {
            YTKBaseRequest *ytkb    = (YTKBaseRequest *)(batchRequest.requestArray[i]);
            NSLog(@"info: %@", [ytkb.responseJSONObject objectForKey:@"data"]);
            [self.BoxOfficeDic setObject:[ytkb.responseJSONObject objectForKey:@"data"] forKey:keys[i]];
        }
        
        [self.tableView reloadData];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
        [self fetchObjects];
    }];
}

#pragma mark - Table view data source
/*!
 *  @brief 由于返回的josn数据类型不一致，所以这里需要进行处理
 *      实时票房（hour）
 *      日、周末、月票房格式一致
 *      全球票房
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:kBoxOfficeCellID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray      *eleArr    = nil;
    [cell.titleLabel setText: @""];
    
    if (indexPath.row == 0) {
        eleArr = [[self.BoxOfficeDic objectForKey:keys[0]] objectForKey:@"data2"];
    }
    else if (indexPath.row < 4){
        NSLog(@"indexPath.row %ld", (long)indexPath.row);
        eleArr = [[self.BoxOfficeDic objectForKey:keys[indexPath.row]] objectForKey:@"data1"];
    } else {
        eleArr = [self.BoxOfficeDic objectForKey:keys[indexPath.row]];
    }
    
    @try {
        [cell.nameLeftLabel     setText: eleArr[0][@"MovieName"]];
        [cell.nameCenterLabel   setText: eleArr[1][@"MovieName"]];
        [cell.nameRightLabel    setText: eleArr[2][@"MovieName"]];
        
        NSString *boxOfficeKey = @"";
        if (indexPath.row != 0) {
            boxOfficeKey = @"sumBoxOffice";
        } else {
            boxOfficeKey = @"";
        }

        [cell.boxOfficeLeftLabel    setText: eleArr[0][@"sumBoxOffice"]];
        [cell.boxOfficeCenterLabel  setText: eleArr[1][@"sumBoxOffice"]];
        [cell.boxOfficeRightLabel   setText: eleArr[2][@"sumBoxOffice"]];
        
        NSString *imgStrLeft = [ImageSuffix stringByAppendingString:eleArr[0][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrLeft] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        NSString *imgStrCenter = [ImageSuffix stringByAppendingString:eleArr[1][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrCenter] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        NSString *imgStrRight = [ImageSuffix stringByAppendingString:eleArr[2][@"MovieImg"]];
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrRight] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    @catch (NSException *exception) {
            
    }
    @finally {
            
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
