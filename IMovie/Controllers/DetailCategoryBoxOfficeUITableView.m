//
//  DetailCategoryBoxOfficeUITableView.m
//  IMovie
//
//  Created by sys on 16/3/3.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "DetailCategoryBoxOfficeUITableView.h"
#import "EColumnChart.h"
#import "EFloatBox.h"
#import "BoxOfficeRequest.h"
#import "DetailCategoryBOTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "IMTAPI.h"

@interface DetailCategoryBoxOfficeUITableView()
{
}

@property (nonatomic, strong) EColumnChart  *eColumnChart;
@property (nonatomic, strong) EColumn       *eColumnSelected;
@property (nonatomic, strong) EFloatBox     *eFloatBox;
@property (nonatomic, strong) UILabel       *valueLabel;
@property (nonatomic, strong) UIColor       *tempColor;
@property (nonatomic, strong) NSDictionary  *data;
@property (nonatomic, strong) NSArray       *eleArr;

@end

static NSString *kDetailCategoryBoxOfficeCellID = @"DetailCategoryBoxOfficeCellID";

@implementation DetailCategoryBoxOfficeUITableView

-(void)viewDidLoad
{
    
    [self.tableView registerClass:[DetailCategoryBOTableViewCell class] forCellReuseIdentifier:kDetailCategoryBoxOfficeCellID];
    [self fetchObjects];
}

#pragma mark - Function

-(void)fetchObjects
{
    BoxOfficeRequest *bor = [[BoxOfficeRequest alloc] initWithType:_type withPara:_para];
    [bor startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"succeed");
        NSLog(@"data: %@", request.responseJSONObject);
        _data = [request.responseJSONObject copy];
        [self.tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}

#pragma mark - delegate & datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.row %ld", (long)indexPath.row);
    
    DetailCategoryBOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCategoryBoxOfficeCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.titleLabel setText: @""];
    
    @try {
        
        if ( _type == BoxOfficeTypeHour) {
            
            _eleArr = [[_data objectForKey:@"data"] objectForKey:@"data2"];
            //eleArr = [[self.BoxOfficeDic objectForKey:keys[0]] objectForKey:@"data2"];
            // [self updateBoxOfficeHour:eleArr];
            // [self initEChart];
        } else if(_type == BoxOfficeTypeGlobal) {
            _eleArr = [_data objectForKey:@"data"];
        }
        else if (indexPath.row < 4){
            _eleArr = [[_data objectForKey:@"data"] objectForKey:@"data1"];
        }
        
        [cell.titleLabel     setText: [[_eleArr objectAtIndex:indexPath.row] objectForKey: @"MovieName"]];
        
        NSString *boxOfficeKey = @"";
        if (indexPath.row != 0) {
            boxOfficeKey = @"sumBoxOffice";
        } else {
            boxOfficeKey = @"";
        }
        
        [cell.directorLabel setText:[[_eleArr objectAtIndex:indexPath.row] objectForKey:@"Director"]];
        [cell.boxOfficeLabel   setText: [[_eleArr objectAtIndex:indexPath.row] objectForKey:@"BoxOffice"]];
        [cell.sumBoxOfficeLabel setText: [[_eleArr objectAtIndex:indexPath.row] objectForKey:@"SumBoxOffice"]];
        
        NSString *imgStr    = NULL;
        
        if (_type == BoxOfficeTypeHour) {
            // 实时票房
            imgStr     = [ImageSuffix stringByAppendingString:[_eleArr objectAtIndex:indexPath.row][@"MovieImg"]];
        } else if(_type == BoxOfficeTypeDay) {
            // 日票房
            imgStr     = [@"http://www.cbooo.cn/" stringByAppendingString:[_eleArr objectAtIndex:indexPath.row][@"MovieImg"]];
            
        } else {
            // 周末票房 月票房 全球票房
            imgStr     = [[_eleArr objectAtIndex:indexPath.row] objectForKey:@"DefaultImage"];
        }
        
        [cell.image setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
