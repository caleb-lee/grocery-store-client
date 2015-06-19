//
//  GRSInventoryListViewController.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/19.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryListViewController.h"

@interface GRSInventoryListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshButtonAction:(id)sender;

@property (strong, nonatomic) NSDictionary *inventoryList;

@end

static NSString *const BaseURLString = @"http://127.0.0.1:4567/api/";

@implementation GRSInventoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadGroceryInventory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGroceryInventory
{
    NSString *urlString = [NSString stringWithFormat:@"%@inventory", BaseURLString];
    
    [[AFHTTPRequestOperationManager manager] GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *groceryInventory = (NSDictionary *)responseObject;
        self.inventoryList = groceryInventory;
        
        [self.tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@", error);
    }];
}

- (IBAction)refreshButtonAction:(id)sender
{
    [self loadGroceryInventory];
}

#pragma Mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inventoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *itemName = [self.inventoryList allKeys][indexPath.row];
    NSNumber *itemQuantity = [self.inventoryList objectForKey:itemName];
    
    cell.textLabel.text = itemName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", itemQuantity];
    
    return cell;
}

@end
