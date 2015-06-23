//
//  GRSInventoryListViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryListViewController.h"

#import "GRSInventoryDetailViewController.h"
#import "GRSInventoryFetchedResultsDataSource.h"
#import "GRSSyncUtility.h"

@interface GRSInventoryListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshButtonAction:(id)sender;

@property (strong, nonatomic) NSString *selectedItemName;
@property (strong, nonatomic) GRSInventoryFetchedResultsDataSource *dataSource;

@end

@implementation GRSInventoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[GRSInventoryFetchedResultsDataSource alloc] initWithTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshButtonAction:(id)sender
{
    [[GRSSyncUtility sharedUtility] downSync:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GRSInventoryDetailViewController *dest = segue.destinationViewController;
    self.dataSource.delegate = dest;
}

@end
