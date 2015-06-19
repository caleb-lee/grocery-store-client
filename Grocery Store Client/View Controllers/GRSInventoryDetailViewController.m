//
//  GRSInventoryDetailViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryDetailViewController.h"

@interface GRSInventoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

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
    NSString *urlString = [NSString stringWithFormat:@"%@inventory/%@", BaseURLString, self.itemName];
    
    [[AFHTTPRequestOperationManager manager] GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *groceryInventory = (NSDictionary *)responseObject;
        
        self.quantityLabel.text = [NSString stringWithFormat:@"Qty: %@", [groceryInventory objectForKey:self.itemName]];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
