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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchaseButtonAction:(id)sender
{
    [[GRSShoppingCart sharedInstance] purchaseProductsInCart:^(NSArray *products, NSError *error){
        if (error) {
            [UIAlertController presentAlertWithTitle:@"Error"
                                          andMessage:error.localizedDescription
                                    inViewController:self];
        } else {
            [UIAlertController presentAlertWithTitle:@"Shopping Cart"
                                          andMessage:@"The items in this cart have been successfully purchased."
                                    inViewController:self];
            
            [self.tableView reloadData];
        }
    }];
}

#pragma Mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *productName = [[GRSShoppingCart sharedInstance].productsInCart.allKeys objectAtIndex:indexPath.row];
        
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
    
    NSString *productName = [[GRSShoppingCart sharedInstance].productsInCart.allKeys objectAtIndex:indexPath.row];
    NSNumber *quantityToBuy = [[GRSShoppingCart sharedInstance].productsInCart objectForKey:productName];
    
    cell.textLabel.text = productName;
    cell.detailTextLabel.text = quantityToBuy.stringValue;
    
    return cell;
}

@end
