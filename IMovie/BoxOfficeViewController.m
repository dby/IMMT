//
//  BoxOfficeViewController.m
//  IMovie
//
//  Created by sys on 16/2/25.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "BoxOfficeViewController.h"
#import "DetailCategoryBoxOfficeUITableView.h"

#import "IMTAPI.h"
#import "BoxOfficeCell.h"
#import <MBProgressHUD.h>
#import "YTKBatchRequest.h"
#import "BoxOfficeRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "EColumnChart.h"
#import "EFloatBox.h"
#import "EColor.h"


static NSString *kBoxOfficeCellID = @"BoxOfficeCellID";

@interface BoxOfficeViewController () <EColumnChartDelegate, EColumnChartDataSource>
{
    NSArray *keys;
    NSArray *typesArr;
}

@property (nonatomic, strong) BoxOfficeCell *propertyCell;
@property(nonatomic, strong) NSMutableDictionary *BoxOfficeDic;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, strong) NSDate *lastRefreshTime;
@property (nonatomic, copy)   NSString *kLastRefreshTime;

@property (nonatomic, strong) EColumnChart *eColumnChart;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIColor *tempColor;
@property (nonatomic, strong) NSArray *data;

@end


@implementation BoxOfficeViewController
@synthesize data = _data;
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize valueLabel = _valueLabel;
@synthesize eColumnChart = _eColumnChart;
@synthesize eColumnSelected = _eColumnSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self.tableView registerClass:[BoxOfficeCell class] forCellReuseIdentifier:kBoxOfficeCellID];
    [self fetchObjects];
}

#pragma mark - Init

- (void)initData
{
    self.BoxOfficeDic = [NSMutableDictionary dictionaryWithCapacity:6];
    keys = @[@"hour", @"day", @"weekend", @"month" ,@"global"];
    
}

/*!
 *  @brief 初始化EChart，只有获得数据之后，在初始化
 */
- (void)initEChart
{
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(30, 30, CGRectGetWidth(self.view.frame) - 30, 200)];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 50, 3, 150, 30)];
    _valueLabel.font = [UIFont systemFontOfSize:12];
    [_valueLabel setTextColor:[UIColor blackColor]];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 230)];
    [headView addSubview:_valueLabel];
    [headView addSubview:_eColumnChart];
    
    self.tableView.tableHeaderView = headView;
}

#pragma mark - Function

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
            [self.BoxOfficeDic setObject:[ytkb.responseJSONObject objectForKey:@"data"] forKey:keys[i]];
        }
        
        [self.tableView reloadData];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
        [self fetchObjects];
    }];
}

- (void)updateBoxOfficeHour:(NSArray *)arr
{
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < [arr count]; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[arr[i] objectForKey:@"MovieName"]
                                                                               value:[[arr[i] objectForKey:@"BoxOffice"] integerValue]
                                                                               index:i
                                                                                unit:@"元"];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
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
    self.propertyCell = cell;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray      *eleArr    = nil;
    [cell.titleLabel setText: @""];
    
    @try {
        
        if (indexPath.row == 0) {
            eleArr = [[self.BoxOfficeDic objectForKey:keys[0]] objectForKey:@"data2"];
            [self updateBoxOfficeHour:eleArr];
            [self initEChart];
        }
        else if (indexPath.row < 4){
            eleArr = [[self.BoxOfficeDic objectForKey:keys[indexPath.row]] objectForKey:@"data1"];
        } else {
            eleArr = [self.BoxOfficeDic objectForKey:keys[indexPath.row]];
        }
    
        [cell.nameLeftLabel     setText: eleArr[0][@"MovieName"]];
        [cell.nameCenterLabel   setText: eleArr[1][@"MovieName"]];
        [cell.nameRightLabel    setText: eleArr[2][@"MovieName"]];
        
        NSString *boxOfficeKey = @"";
        if (indexPath.row != 0) {
            boxOfficeKey = @"sumBoxOffice";
        } else {
            boxOfficeKey = @"";
        }

        [cell.boxOfficeLeftLabel    setText: eleArr[0][@"BoxOffice"]];
        [cell.boxOfficeCenterLabel  setText: eleArr[1][@"BoxOffice"]];
        [cell.boxOfficeRightLabel   setText: eleArr[2][@"BoxOffice"]];
        
        NSString *imgStrLeft    = NULL;
        NSString *imgStrCenter  = NULL;
        NSString *imgStrRight   = NULL;
        
        if (indexPath.row == 0) {
            // 实时票房
            imgStrLeft      = [ImageSuffix stringByAppendingString:eleArr[0][@"MovieImg"]];
            imgStrCenter    = [ImageSuffix stringByAppendingString:eleArr[1][@"MovieImg"]];
            imgStrRight     = [ImageSuffix stringByAppendingString:eleArr[2][@"MovieImg"]];
        } else if(indexPath.row == 1) {
            // 日票房
            imgStrLeft      = [@"http://www.cbooo.cn/" stringByAppendingString:eleArr[0][@"MovieImg"]];
            imgStrCenter    = [@"http://www.cbooo.cn/" stringByAppendingString:eleArr[1][@"MovieImg"]];
            imgStrRight     = [@"http://www.cbooo.cn/" stringByAppendingString:eleArr[2][@"MovieImg"]];
            
        } else {
            // 周末票房 月票房 全球票房
            imgStrLeft      = [eleArr[0] objectForKey:@"DefaultImage"];
            imgStrCenter    = [eleArr[1] objectForKey:@"DefaultImage"];
            imgStrRight     = [eleArr[2] objectForKey:@"DefaultImage"];
        }
        
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:imgStrLeft] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        [cell.imageCenter setImageWithURL:[NSURL URLWithString:imgStrCenter] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        [cell.imageRight setImageWithURL:[NSURL URLWithString:imgStrRight] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailCategoryBoxOfficeUITableView *dcbouit = [[DetailCategoryBoxOfficeUITableView alloc] init];
    
    if (indexPath.row == 0) {
        dcbouit.type = BoxOfficeTypeHour;
        dcbouit.para = NULL;
    } else if(indexPath.row == 1) {
        dcbouit.type = BoxOfficeTypeDay;
        dcbouit.para = @{@"num":@"0"};
    } else if(indexPath.row == 2) {
        dcbouit.type = BoxOfficeTypeWeekend;
        dcbouit.para = NULL;
    } else if(indexPath.row == 3) {
        dcbouit.type = BoxOfficeTypeMonth;
        dcbouit.para = @{@"sdate":@"2016-1-11"};
    } else if(indexPath.row == 4) {
        dcbouit.type = BoxOfficeTypeGlobal;
        dcbouit.para = @{@"weekId":@"3500"};
    }
    [self.navigationController pushViewController:dcbouit animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0, 0);
    @try {
        BoxOfficeCell *cell = (BoxOfficeCell *)self.propertyCell;
        size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLog(@"h=%f", size.height + 1);
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    return 10  + size.height;
}

#pragma mark - EColumnChartDataSource
/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart
{
    if (_data != nil) {
        return [_data count];
    }
    else {
        return 0;
    }
}

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart
{
    return 10;
}

/** The highest value among the whole chart*/
- (EColumnDataModel *) highestValueEColumnChart:(EColumnChart *) eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

/** Value for each column*/
- (EColumnDataModel *) eColumnChart:(EColumnChart *) eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

#pragma mark - EColumnChartDelegate

/** When finger single taped the column*/
- (void) eColumnChart:(EColumnChart *) eColumnChart didSelectColumn:(EColumn *) eColumn
{
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    _valueLabel.text = [NSString stringWithFormat:@"%@ %.1f", eColumn.eColumnDataModel.label,eColumn.eColumnDataModel.value];
}

/** When finger enter specific column, this is dif from tap*/
- (void) eColumnChart:(EColumnChart *) eColumnChart fingerDidEnterColumn:(EColumn *) eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    NSLog(@"Finger did enter %ld", (long)eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
}

/** When finger leaves certain column, will tell you which column you are leaving*/
- (void) eColumnChart:(EColumnChart *) eColumnChart fingerDidLeaveColumn:(EColumn *) eColumn
{
    NSLog(@"Finger did leave %ld", (long)eColumn.eColumnDataModel.index);
}

/** When finger leaves wherever in the chart, will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
    }
}

@end
