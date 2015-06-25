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

- (IBAction)buyItemAction:(id)sender
{
    GRSInventoryDetailViewController *__weak weakSelf = self;
    
    void (^buyItemCompletion)(NSError *error) = ^void(NSError *error) {
        [weakSelf handleStockChange:error];
        weakSelf.buyTextField.text = @"";
    };
    
    if ([self.buyTextField.text isEqualToString:@""]) {
        [self.selectedProduct purchase:buyItemCompletion];
    } else {
        NSInteger quantity = self.buyTextField.text.integerValue;
        
        [self.selectedProduct purchaseQuantitiy:quantity completion:buyItemCompletion];
    }
}

- (IBAction)restockItemAction:(id)sender
{
    GRSInventoryDetailViewController *__weak weakSelf = self;
    
    void (^restockItemCompletion)(NSError *error) = ^void(NSError *error) {
        [weakSelf handleStockChange:error];
        weakSelf.restockTextField.text = @"";
    };
    
    if ([self.restockTextField.text isEqualToString:@""]) {
        [self.selectedProduct incrementInventory:restockItemCompletion];
    } else {
        NSInteger quantity = self.restockTextField.text.integerValue;
        
        [self.selectedProduct setInventoryQuantity:quantity completion:restockItemCompletion];
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
    GRSInventoryDetailViewController *__weak weakSelf = self;
    
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
