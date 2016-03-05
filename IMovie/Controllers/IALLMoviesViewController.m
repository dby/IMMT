//
//  IALLMoviesViewController.m
//  IMovie
//
//  Created by sys on 16/2/25.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "IALLMoviesViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface IALLMoviesViewController ()

@property (nonatomic, strong) NSArray* data;

@end

static NSString *kMovieCellID = @"MovieCellID";

@implementation IALLMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerClass:[BoxOfficeCell class] forCellReuseIdentifier:kMovieCellID];
    [self fetchObjects];
}


#pragma mark - Function

-(void)fetchObjects
{
    MovieRequest *bor = [[MovieRequest alloc] initWithType:MovieRequestTypeOnShowing withPara:NULL];
    [bor startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"succeed");
        
        _data = [request.responseJSONObject objectForKey:@"data"];
        [self.tableView reloadData];
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}

#pragma mark - delegate & datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:kMovieCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.titleLabel setText: @""];
    
    @try {
        
        [cell.nameLeftLabel setText:_data[0][@"title"]];
        [cell.nameCenterLabel setText:_data[1][@"title"]];
        [cell.nameRightLabel setText:_data[2][@"title"]];
        
        [cell.boxOfficeLeftLabel setText:_data[0][@"rate"]];
        [cell.boxOfficeCenterLabel setText:_data[1][@"rate"]];
        [cell.boxOfficeRightLabel setText:_data[2][@"rate"]];
        
        [cell.imageLeft setImageWithURL:[NSURL URLWithString:_data[0][@"cover"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.imageCenter setImageWithURL:[NSURL URLWithString:_data[1][@"cover"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.imageRight setImageWithURL:[NSURL URLWithString:_data[2][@"cover"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
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
    return [_data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end
