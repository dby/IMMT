//
//  DetailMITableViewController.m
//  IMovie
//
//  Created by sys on 16/3/13.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "DetailMITableViewController.h"

#import "MovieRequest.h"
#import "DetailMITableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface DetailMITableViewController ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) DetailMITableViewCell *propertyCell;

@end

@implementation DetailMITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponents];
    [self fetchObjects];
}

#pragma Init

- (void)initComponents
{
    self.data = [[NSDictionary alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Function

-(void)fetchObjects
{
    MovieRequest *mr = [[MovieRequest alloc] initWithType:MovieRequestTypeDetailMovieInfo withPara:@{@"id": _movieID}];
    [mr startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"succeed");
        NSLog(@"Detail data: %@", request.responseJSONObject);
        _data = [request.responseJSONObject objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}

#pragma mark - Function

- (void)AddHeaderView:(NSURL *)url {
    UIImageView *uiv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    uiv.contentMode = UIViewContentModeScaleAspectFit;
    [uiv setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.tableView.tableHeaderView = uiv;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailMITableViewCell *cell = (DetailMITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailmoviecell"];
    self.propertyCell = cell;
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailMITableViewCell" owner:self options:nil] lastObject];
    }
    
    [cell.name setText:[_data objectForKey:@"anothername"]];
    [cell.type setText:[_data objectForKey:@"type"]];
    [cell.intro setText:[_data objectForKey:@"intro"]];
    [cell.director_release setText:[_data objectForKey:@"director"]];
    
    [self AddHeaderView:[NSURL URLWithString:[_data objectForKey:@"cover"]]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0, 0);
    @try {
        DetailMITableViewCell *cell = (DetailMITableViewCell *)self.propertyCell;
        size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLog(@"h=%f", size.height + 1);
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return 10  + size.height;
}

@end
