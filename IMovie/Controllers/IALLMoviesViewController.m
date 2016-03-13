//
//  IALLMoviesViewController.m
//  IMovie
//
//  Created by sys on 16/2/25.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "IALLMoviesViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "BoxOfficeRequest.h"
#import "YTKBatchRequest.h"

#import "PraiseTableViewController.h"

@interface IALLMoviesViewController ()

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) BoxOfficeCell *propertyCell;

@end

static NSString *kMovieCellID = @"MovieCellID";

@implementation IALLMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initComponents];
    [self.tableView registerClass:[BoxOfficeCell class] forCellReuseIdentifier:kMovieCellID];
    [self fetchObjects];
}

#pragma mark - Init

- (void)initComponents
{
    _data = [[NSMutableArray alloc] init];
}

#pragma mark - Function

-(void)fetchObjects
{
    MovieRequest *onShowingMoviesRequest = [[MovieRequest alloc] initWithType:MovieRequestTypeOnShowing withPara:NULL];
    MovieRequest *NewMovieRankRequest = [[MovieRequest alloc]initWithType:MovieRequestTypeNewMovieRankingList withPara:NULL];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[onShowingMoviesRequest, NewMovieRankRequest]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        
        for (int i = 0; i < batchRequest.requestArray.count; i++) {
            YTKBaseRequest *ytkb    = (YTKBaseRequest *)(batchRequest.requestArray[i]);
            NSLog(@"success: %@", ytkb.responseJSONObject);
            
            _data[i] = [ytkb.responseJSONObject objectForKey:@"data"];
        }
        
        [self.tableView reloadData];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
        [self fetchObjects];
    }];
}

#pragma mark - delegate & datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:kMovieCellID forIndexPath:indexPath];
    
    self.propertyCell = cell;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    @try {
        if (indexPath.row == 0) {
            [cell.titleLabel setText: @"热映的"];
        } else if(indexPath.row == 1) {
            [cell.titleLabel setText: @"口碑榜"];
        }
        
        NSArray *tmp = [_data objectAtIndex:indexPath.row];
        
        [cell.nameLeftLabel setText:tmp[0][@"title"]];
        [cell.nameCenterLabel setText:tmp[1][@"title"]];
        [cell.nameRightLabel setText:tmp[2][@"title"]];
        
        [cell.boxOfficeLeftLabel setText:tmp[0][@"rate"]];
        [cell.boxOfficeCenterLabel setText:tmp[1][@"rate"]];
        [cell.boxOfficeRightLabel setText:tmp[2][@"rate"]];
        
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:tmp[0][@"cover"]]
                       placeholderImage:nil
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.imageCenter setImageWithURL:[NSURL URLWithString:tmp[1][@"cover"]]
                         placeholderImage:nil
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.imageRight setImageWithURL:[NSURL URLWithString:tmp[2][@"cover"]]
                        placeholderImage:nil
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PraiseTableViewController *ptvc = [[PraiseTableViewController alloc] init];
    ptvc.url = @"";
    [self.navigationController pushViewController:ptvc animated:YES];
}

@end
