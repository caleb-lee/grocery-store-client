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

/**
 *  Purchases this product. Completion is called when the purchase
 *  is complete or fails. NSError will be nil if successful. Syncs to
 *  server.
 *
 *  @param completion the completion handler that's called when done
 */
- (void)purchase:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

/**
 *  Purchases a particular quantity of this product. Completion is called
 *  when the purchase is complete or fails. NSError will be nil if successful.
 *  Syncs to server.
 *
 *  @param quantity   the quantity to purchase
 *  @param completion the completion handler that is called when the purchase is done
 */
- (void)purchaseQuantitiy:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

/**
 *  Increments the inventory of this product. Completion is called when the 
 *  increment is done, successful or not. NSError will be nil if successful.
 *  Syncs to server.
 *
 *  @param completion the completion handler that is called when the purchase is done.
 */
- (void)incrementInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

/**
 *  Sets the inventory of this product to the given quantity. Completion is called when the
 *  setting is complete or fails. NSError will be nil if successful. Syncs to server.
 *
 *  @param quantity   new quantity for this product
 *  @param completion the completion handler that is called when the increment is done
 */
- (void)setInventoryQuantity:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

/**
 *  Sets the inventory of this product to 0. Completion is called when the zeroing is complete
 *  or fails. NSError will be nil if successful. Syncs to server.
 *
 *  @param completion the completion handler that's called when the zeroing is done
 */
- (void)setNoInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

@end
