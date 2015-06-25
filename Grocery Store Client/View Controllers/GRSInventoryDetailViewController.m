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
#import "GRSShoppingCart.h"
#import "Product+API_Interaction.h"

@interface GRSInventoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

- (IBAction)buyItemAction:(id)sender;
- (IBAction)restockItemAction:(id)sender;
- (IBAction)addToCartAction:(id)sender;
- (IBAction)removeAllStockAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *buyTextField;
@property (weak, nonatomic) IBOutlet UITextField *restockTextField;
@property (weak, nonatomic) IBOutlet UITextField *addToCartTextField;

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
    self.navigationItem.title = self.selectedProduct.name.capitalizedString;
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
    if ([self.buyTextField.text isEqualToString:@""]) {
        [self.selectedProduct purchase:^(NSError *error){
            [self handleStockChange:error];
        }];
    } else {
        NSInteger quantity = self.buyTextField.text.integerValue;
        
        [self.selectedProduct purchaseQuantitiy:quantity completion:^(NSError *error){
            [self handleStockChange:error];
            self.buyTextField.text = @"";
        }];
    }
}

- (IBAction)restockItemAction:(id)sender
{
    if ([self.restockTextField.text isEqualToString:@""]) {
        [self.selectedProduct incrementInventory:^(NSError *error){
            [self handleStockChange:error];
        }];
    } else {
        NSInteger quantity = self.restockTextField.text.integerValue;
        __weak GRSInventoryDetailViewController *weakSelf = self;
        
        [self.selectedProduct setInventoryQuantity:quantity completion:^(NSError *error){
            [weakSelf handleStockChange:error];
            weakSelf.restockTextField.text = @"";
        }];
    }
}

- (IBAction)addToCartAction:(id)sender
{
    NSInteger quantity;
    
    if ([self.addToCartTextField.text isEqualToString:@""]) {
        quantity = 1;
    } else {
        quantity = self.addToCartTextField.text.integerValue;
    }
    
    [[GRSShoppingCart sharedInstance] addProductToCart:self.selectedProduct quantity:quantity];
    self.addToCartTextField.text = @"";
    [UIAlertController presentAlertWithTitle:@"Shopping Cart"
                                  andMessage:[NSString stringWithFormat:@"Added a quantity of %ld %@ to the shopping cart.", quantity, self.selectedProduct.name]
                            inViewController:self];
}

- (IBAction)removeAllStockAction:(id)sender
{
    __weak GRSInventoryDetailViewController *weakSelf = self;
    
    [self.selectedProduct setNoInventory:^(NSError *error){
        [weakSelf handleStockChange:error];
    }];
}

// returns YES if the error is fatal
- (void)handleStockChange:(NSError *)error
{
    if (error) {
        [UIAlertController presentAlertWithTitle:@"Error"
                                      andMessage:error.localizedDescription
                                inViewController:self];
    } else {
        [self loadItemData];
    }
}

@end
