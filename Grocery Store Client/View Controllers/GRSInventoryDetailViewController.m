//
//  GRSInventoryDetailViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryDetailViewController.h"

#import "GRSNetworkAPIUtility.h"

@interface GRSInventoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyItemButton;
@property (weak, nonatomic) IBOutlet UIButton *restockItemButton;

- (IBAction)buyItemAction:(id)sender;
- (IBAction)restockItemAction:(id)sender;

@end

static NSString *const BaseURLString = @"http://127.0.0.1:4567/api/";

@implementation GRSInventoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.itemName;
    self.quantityLabel.text = @"";
    
    [self loadItemData];
}

- (void)loadItemData
{
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:self.itemName completion:^(NSDictionary *userInfo, NSError *error) {
        [self updateQuantityLabel:[userInfo objectForKey:self.itemName]];
        self.buyItemButton.titleLabel.text = [NSString stringWithFormat:@"Buy %@", self.itemName];
        self.restockItemButton.titleLabel.text = [NSString stringWithFormat:@"Restock %@", self.itemName];
    }];
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
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:self.itemName completion:^(NSDictionary *userInfo, NSError *error) {
        [self updateQuantityLabel:[userInfo objectForKey:self.itemName]];
    }];
}

- (IBAction)restockItemAction:(id)sender
{
    [[GRSNetworkAPIUtility sharedUtility] incrementInventoryQuantityForProductWithName:self.itemName completion:^(NSDictionary *userInfo, NSError *error) {
        [self updateQuantityLabel:[userInfo objectForKey:self.itemName]];
    }];
}

@end
