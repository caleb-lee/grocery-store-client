//
//  GRSInventoryFetchedResultsDataSource.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/23.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSInventoryFetchedResultsDataSource.h"
#import "Product.h"

@implementation GRSInventoryFetchedResultsDataSource

- (id)initWithTableView:(UITableView *)tableView
{
    self = [self initWithPredicate:nil
                         cacheName:nil
                         tableView:tableView
                sectionNameKeyPath:nil
                   sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]
                managedObjectClass:[Product class]
                          delegate:nil];
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Product *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", product.quantity];
    
    return cell;
}

@end
