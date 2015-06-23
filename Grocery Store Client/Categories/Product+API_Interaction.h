//
//  Product+API_Interaction.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "Product.h"
#import "GRSNetworkAPIUtility.h"

@interface Product (API_Interaction)

- (void)purchase:(GRSNetworkNoResponseNetworkCompletionBlock)completion;
- (void)purchaseQuantitiy:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;
- (void)incrementInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion;
- (void)setInventoryQuantity:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;
- (void)setNoInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

@end
