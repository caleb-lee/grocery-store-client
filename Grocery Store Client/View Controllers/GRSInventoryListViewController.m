//
//  GRSInventoryListViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryListViewController.h"

#import "UIAlertController+Convenience.h"

#import "GRSInventoryDetailViewController.h"
#import "GRSSyncUtility.h"
#import "Product.h"

static NSString *const ListToDetailSegue = @"InventoryListToProductDetailSegue";

@interface GRSInventoryListViewController () <VOKFetchedResultsDataSourceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshButtonAction:(id)sender;

@property (strong, nonatomic) NSString *selectedItemName;
@property (strong, nonatomic) GRSInventoryFetchedResultsDataSource *dataSource;

@property (strong, nonatomic) Product *selectedProduct;

@end

@implementation GRSInventoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[GRSInventoryFetchedResultsDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (IBAction)refreshButtonAction:(id)sender
{
    [self refresh];
}

- (void)refresh
{
    [[GRSSyncUtility sharedUtility] downSync:^(NSError *error){
        if (error) {
            [UIAlertController presentAlertWithTitle:@"Error"
                                          andMessage:error.localizedDescription
                                    inViewController:self];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ListToDetailSegue]) {
        GRSInventoryDetailViewController *dest = segue.destinationViewController;
        dest.selectedProduct = self.selectedProduct;
    }
}

#pragma Mark - VOKFetchedResultsDataSourceDelegate

- (void)fetchResultsDataSourceSelectedObject:(NSManagedObject *)object
{
    self.selectedProduct = (Product *)object;
    [self performSegueWithIdentifier:ListToDetailSegue sender:self];
}

@end
