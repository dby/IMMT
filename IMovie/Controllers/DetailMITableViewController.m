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
#import "PhotosTableViewCell.h"
#import "EssayTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#import "YTKBatchRequest.h"

@interface DetailMITableViewController ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableViewCell *propertyCell;

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
    self.data = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Function

-(void)fetchObjects
{
    MovieRequest *mr = [[MovieRequest alloc] initWithType:MovieRequestTypeDetailMovieInfo
                                                 withPara:@{@"id": _movieID}];
    MovieRequest *reviews = [[MovieRequest alloc] initWithType:MovieRequestTypeBestReview
                                                     withPara:@{@"id": _movieID,
                                                                @"start": @0,
                                                                @"limit": @3,
                                                                @"sort":@"",
                                                                @"score":@""
                                                                }];
    MovieRequest *essays = [[MovieRequest alloc] initWithType:MovieRequestTypeEssays
                                                     withPara:@{@"id": _movieID,
                                                                @"start": @0,
                                                                @"limit": @6,
                                                                @"sort":@"time"
                                                                }];
    
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[mr, reviews, essays]];
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
    /*
    [mr startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"succeed");
        //NSLog(@"Detail data: %@", request.responseJSONObject);
        _data = [request.responseJSONObject objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
     */
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // Movie 详细信息
        
        DetailMITableViewCell *cell = (DetailMITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailmoviecell"];
        self.propertyCell = cell;
    
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailMITableViewCell" owner:self options:nil] lastObject];
        }
    
        @try {
            [cell.name  setText:[[_data objectAtIndex:0] objectForKey:@"anothername"]];
            [cell.type  setText:[[_data objectAtIndex:0] objectForKey:@"type"]];
            [cell.intro setText:[[_data objectAtIndex:0] objectForKey:@"intro"]];
            
            [cell.director_release setText:[[_data objectAtIndex:0] objectForKey:@"director"]];
        
            [self AddHeaderView:[NSURL URLWithString:[[_data objectAtIndex:0] objectForKey:@"cover"]]];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception.debugDescription);
        }
        @finally {
        }
        return cell;
        
        return nil;
        
    }
    else if (indexPath.row == 1) {
        // Movie 海报
        
        PhotosTableViewCell *cell = (PhotosTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photocell"];
        self.propertyCell = cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotosTableViewCell" owner:self options:nil] lastObject];
        }
        @try {
            
            CGFloat x = 0;
            CGRect frame = CGRectMake(0, 0, 150, 150);
            NSInteger num = [[[_data objectAtIndex:0] objectForKey:@"covers"] count] > PhotoNum ? PhotoNum : [[[_data objectAtIndex:0] objectForKey:@"covers"] count];
        
            for (int i = 0; i < num; i++) {
                frame.origin.x = x;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                imageView.clipsToBounds = YES;
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                NSLog(@"url: %@", [[[_data objectAtIndex:0] objectForKey:@"covers"] objectAtIndex:i]);
                [imageView setImageWithURL:[NSURL URLWithString:[[[_data objectAtIndex:0] objectForKey:@"covers"] objectAtIndex:i]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                //[imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBig:)]];
                [cell.photoscrollview addSubview:imageView];
                x += (frame.size.width+5);
            }
            cell.photoscrollview.contentSize = CGSizeMake(150 * num, 0);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
        }
        
        return cell;
    }
    else if (indexPath.row == 2) {
        // 短评
        EssayTableViewCell *cell = (EssayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"essaycell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EssayTableViewCell" owner:self options:nil] lastObject];
        }
        self.propertyCell = cell;
        @try {
            
            NSDictionary *tmp = [[[_data objectAtIndex:2] objectAtIndex:indexPath.row] copy];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[tmp objectForKey:@"author_img"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.author setText:[tmp objectForKey:@"author_name"]];
            [cell.content setText:[tmp objectForKey:@"essay_content"]];
            [cell.time setText:[tmp objectForKey:@"essay_time"]];
            [cell.vote setText:[tmp objectForKey:@"essay_vote"]];
        }
        
        @catch (NSException *exception) {
            
            NSLog(@"index.row == 2, %@", exception.description);
        }
        @finally {
            
        }
        
        return cell;
        
    } else {
        // 影评
        
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0, 0);
    @try {
        DetailMITableViewCell *cell = (DetailMITableViewCell *)self.propertyCell;
        size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    if (indexPath.row == 1) {
        return 200;
    } else {
        return 10  + size.height;
    }
}

@end