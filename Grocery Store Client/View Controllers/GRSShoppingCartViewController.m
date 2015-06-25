//
//  GRSShoppingCartViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/24.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSShoppingCartViewController.h"

#import "GRSShoppingCart.h"
#import "UIAlertController+Convenience.h"

@interface GRSShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate>

- (IBAction)purchaseButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GRSShoppingCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (IBAction)purchaseButtonAction:(id)sender
{
    GRSShoppingCartViewController *__weak weakSelf = self;
    
    [[GRSShoppingCart sharedInstance] purchaseProductsInCart:^(NSArray *products, NSError *error){
        if (error) {
            [UIAlertController presentAlertWithTitle:@"Error"
                                          andMessage:error.localizedDescription
                                    inViewController:weakSelf];
        } else {
            [UIAlertController presentAlertWithTitle:@"Shopping Cart"
                                          andMessage:@"The items in this cart have been successfully purchased."
                                    inViewController:weakSelf];
            
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSString *)productNameFromIndexPath:(NSIndexPath *)indexPath
{
    return [GRSShoppingCart sharedInstance].productsInCart.allKeys[indexPath.row];
}

#pragma Mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *productName = [self productNameFromIndexPath:indexPath];
        
        [[GRSShoppingCart sharedInstance] removeProductWithNameFromCart:productName];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma Mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GRSShoppingCart sharedInstance].productsInCart.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *productName = [self productNameFromIndexPath:indexPath];
    NSNumber *quantityToBuy = [GRSShoppingCart sharedInstance].productsInCart[productName];
    
    cell.textLabel.text = productName;
    cell.detailTextLabel.text = quantityToBuy.stringValue;
    
    return cell;
}

@end
