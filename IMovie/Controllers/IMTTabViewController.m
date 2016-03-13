//
//  IMTViewController.m
//  IMovie
//
//  Created by sys on 16/2/25.
//  Copyright © 2016年 sys. All rights reserved.
//

#import "IMTTabViewController.h"

#import "MineTableViewController.h"
#import "ITVViewController.h"
#import "IMusicTableViewController.h"

#import "BoxOfficeViewController.h"
#import "MovieScheViewController.h"
#import "IALLMoviesViewController.h"
#import "SearchMovieViewController.h"

#import "SwipableViewController.h"

@interface IMTTabViewController ()
{
    MineTableViewController *mineTableViewController;
    ITVViewController *iTVViewController;
    IMusicTableViewController * iMusicTableViewController;
    
    
    BoxOfficeViewController *boxOfficeViewController;
    MovieScheViewController *movieScheViewController;
    IALLMoviesViewController *iAllMoviesViewController;
    SearchMovieViewController *searchMovieViewController;
}
@end

@implementation IMTTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    boxOfficeViewController = [[BoxOfficeViewController alloc] init];
    movieScheViewController = [[MovieScheViewController alloc] init];
    iAllMoviesViewController = [[IALLMoviesViewController alloc] init];
    searchMovieViewController = [[SearchMovieViewController alloc] init];
    
    mineTableViewController = [[MineTableViewController alloc] init];
    iTVViewController = [[ITVViewController alloc] init];
    iMusicTableViewController = [[IMusicTableViewController alloc] init];
    
    
    SwipableViewController *movieSVC = [[SwipableViewController alloc] initWithTitle:@"电影"
                                                                       andSubTitles:@[
                                                                                      @"票房",
                                                                                      @"影评",
                                                                                      @"电影",
                                                                                      @"搜索"
                                                                                      ]
                                                                     andControllers:@[
                                                                                      boxOfficeViewController,
                                                                                      movieScheViewController,
                                                                                      iAllMoviesViewController,
                                                                                      searchMovieViewController,
                                                                                      ]
                                                                        underTabbar:YES];
    // tabbar 是否半透明
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             iTVViewController,
                             [self addNavigationItemForViewController:movieSVC],
                             iMusicTableViewController,
                             mineTableViewController,
                             ];
    
    NSArray *titles = @[@"电视", @"电影", @"音乐",@"我的"];
    NSArray *images = @[@"", @"", @"", @""];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    
}

#pragma mark --

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    /*
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self
                                                                                       action:@selector(onClickMenuButton)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                     target:self
                                                                                                     action:@selector(pushSearchViewController)];
    
    */
    
    return navigationController;
}

@end
