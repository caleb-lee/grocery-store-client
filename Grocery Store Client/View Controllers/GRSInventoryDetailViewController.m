//
//  GRSInventoryDetailViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryDetailViewController.h"

#import "UIAlertController+Convenience.h"

#import "GRSNetworkAPIUtility.h"
#import "Product+API_Interaction.h"

@interface GRSInventoryDetailViewController ()

@property (strong, nonatomic) Product *selectedProduct;

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

- (IBAction)buyItemAction:(id)sender;
- (IBAction)restockItemAction:(id)sender;

@end

@implementation GRSInventoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadItemData];
}

- (void)loadItemData
{
    self.navigationItem.title = self.selectedProduct.name;
    [self updateQuantityLabel:self.selectedProduct.quantity];
}

- (void)updateQuantityLabel:(NSNumber *)quantity
{
    self.quantityLabel.text = [NSString stringWithFormat:@"Qty: %@", quantity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyItemAction:(id)sender
{
    [self.selectedProduct purchase:^(NSError *error){
        [self handleStockChange:error];
    }];
}

- (IBAction)restockItemAction:(id)sender
{
    [self.selectedProduct incrementInventory:^(NSError *error){
        [self handleStockChange:error];
    }];
}

// returns YES if the error is fatal
- (void)handleStockChange:(NSError *)error
{
    if (error != nil) {
        [UIAlertController presentAlertWithTitle:@"Error" andMessage:error.localizedDescription inViewController:self];
    } else {
        [self loadItemData];
    }
}

#pragma Mark - VOKFetchedResultsDataSourceDelegate

- (void)fetchResultsDataSourceSelectedObject:(NSManagedObject *)object
{
    self.selectedProduct = (Product *)object;
}

@end
