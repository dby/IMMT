//
//  PraiseTableViewController.m
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "PraiseTableViewController.h"

#import "MovieRequest.h"
#import "PraiseTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface PraiseTableViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) PraiseTableViewCell *propertyCell;

@end

@implementation PraiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControls];
    [self fetchObjects];
}

#pragma mark - Init

- (void)initControls
{
    _data = [[NSArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Function

-(void)fetchObjects
{
    MovieRequest *mr = [[MovieRequest alloc] initWithType:MovieRequestTypeNewMovieRankingList withPara:NULL];
    [mr startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"succeed");
        NSLog(@"data: %@", request.responseJSONObject);
        _data = [request.responseJSONObject objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_data count]) * 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        PraiseTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"praisecell"];
        self.propertyCell = cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PraiseTableViewCell" owner:self options:nil] lastObject];
        }
    
        if ([_data count] != 0) {
            cell.title.text = [[_data objectAtIndex:(indexPath.row / 2)] objectForKey:@"title"];
            cell.detail.text = [[_data objectAtIndex:(indexPath.row / 2)] objectForKey:@"detail"];
            [cell.cover setImageWithURL:[NSURL URLWithString:[[_data objectAtIndex:(indexPath.row / 2)] objectForKey:@"cover"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        return cell;
        
    } else if (indexPath.row % 2 == 1) {
        static NSString *separatorCellIdentifier = @"SeparatorCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:separatorCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SeparatorCell" owner:self options:nil][0];
            cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.5];
        }
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0, 0);
    @try {
        PraiseTableViewCell *cell = (PraiseTableViewCell *)self.propertyCell;
        size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLog(@"h=%f", size.height + 1);
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    if (indexPath.row % 2 == 0) {
        return 10  + size.height;
    } else {
        return size.height;
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 1) {
        return nil;
    }
    return indexPath;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}
@end