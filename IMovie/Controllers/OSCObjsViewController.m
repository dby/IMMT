//
//  OSCObjsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCObjsViewController.h"
#import "OSCBaseObject.h"
#import "LastCell.h"

#import <MBProgressHUD.h>

@interface OSCObjsViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDate *lastRefreshTime;

@end


@implementation OSCObjsViewController


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _objects = [NSMutableArray new];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }
    
    return self;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor = [UIColor themeColor];
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    _lastCell.textLabel.textColor = [UIColor titleColor];
    
    
    /*** 自动刷新 ***/
    
    if (_needAutoRefresh) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _lastRefreshTime = [_userDefaults objectForKey:_kLastRefreshTime];
        
        if (!_lastRefreshTime) {
            _lastRefreshTime = [NSDate date];
            [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
        }
    }
    
    
    _manager = [AFHTTPRequestOperationManager OSCManager];
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height)
                                animated:YES];
    }
    
    if (_needCache) {
        _manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    [self fetchObjects:YES];
     
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_needAutoRefresh) {
        NSDate *currentTime = [NSDate date];
        if ([currentTime timeIntervalSinceDate:_lastRefreshTime] > _refreshInterval) {
            _lastRefreshTime = currentTime;
            
            [self refresh];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.separatorColor = [UIColor separatorColor];
    
    return _objects.count;
}



#pragma mark - 刷新

- (void)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [self fetchObjects:YES];
    });
    
    //刷新时，增加另外的网络请求功能
    if (self.anotherNetWorking) {
        self.anotherNetWorking();
    }
}


#pragma mark - 请求数据

- (void)fetchObjects:(BOOL)refresh
{
    /*
    [_manager GET:self.generateURL()
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
             
             if (_needAutoRefresh) {
                 [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             MBProgressHUD *HUD = [Utils createHUD];
             HUD.mode = MBProgressHUDModeCustomView;
             HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
             HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
             
             [HUD hide:YES afterDelay:1];
             
             _lastCell.status = LastCellStatusError;
             if (self.tableView.mj_header.isRefreshing) {
                 [self.tableView.mj_header endRefreshing];
             }
             [self.tableView reloadData];
         }
     ];
     */
}


- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}


@end
