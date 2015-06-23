//
//  GRSNetworkAPIUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

/**
 *  GRSNetworkAPIUtility handles all direct API calls in the Grocery Store application
 */

#import <Foundation/Foundation.h>

// --> typedefs taken from Vokal's URLNetworkAPIUtility
/// Completion block for register and login actions. userInfo is set on success, nil on failure.
typedef void(^GRSNetworkUserInfoCompletionBlock)(NSDictionary *userInfo, NSError *error);
/// Completion block for API endpoints that don't return any response body.
typedef void(^GRSNetworkNoResponseNetworkCompletionBlock)(NSError *error);

@interface GRSNetworkAPIUtility : NSObject

 /**
 *  GRSNetworkAPIUtility is a singleton; this method returns the shared instance of GRSNetworkAPIUtility.
 *
 *  @return returns the shared GRSNetworkAPIUtility object
 */
+ (GRSNetworkAPIUtility *)sharedUtility;

/**
 *  Asyncrhonously fetches the product inventory from the server. Calls completion with either the
 *  item inventory in the userInfo NSDictionary or with the error in NSError
 *
 *  @param completion handler that gets called when the server call is done
 */
- (void)fetchProductInventory:(GRSNetworkUserInfoCompletionBlock)completion;

/**
 *  Asyncrhonously fetches a single product and its quantity from the server. Calls completion with
 *  either an NSDictionary containing the product and its quantity or an NSError.
 *
 *  @param name       NSString containing the name of the product we're trying to fetch
 *  @param completion completion handler that gets called when the server call is done
 */
- (void)fetchProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion;

 /**
 *  Asynchronously increments the increments the inventory of the named product. Calls completion with
 *  either an NSDictionary containing the product and its updated quantity or an NSError.
 *
 *  @param name       NSString containing the name of the product we're trying to fetch
 *  @param completion completion handler that gets called when the server call is done
 */
- (void)incrementInventoryQuantityForProductWithName:(NSString *)name
                                          completion:(GRSNetworkUserInfoCompletionBlock)completion;

/**
 *  Asynchronously sets the quantity of a particular product. Calls completion with either an NSDictionary
 *  containing the product and its updated quantity or an NSError.
 *
 *  @param quantity   the new quantity for the product
 *  @param name       the name of the product we're trying to find
 *  @param completion completion handler that gets called when the server call is done
 */
- (void)setInventoryQuantity:(NSInteger)quantity
           toProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion;

/**
 *  Asyncrhonously zeros out the quantity of a particular product. It calls completion regardless of success,
 *  but NSError will be nil if successful
 *
 *  @param name       the name of the product we're trying to find
 *  @param completion completion handler that gets called when the server call is done
 */
- (void)removeAllStockForProductWithName:(NSString *)name
                              completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;

/**
 *  Asynchronously purchases a product (decrements its quantity). It calls completion either with an NSDictionary
 *  containing the product and its updated quantity or an NSError.
 *
 *  @param name       the name of the product we're trying to purchase
 *  @param completion the completion handler that gets called when the server call is done
 */
- (void)purchaseProductWithName:(NSString *)name
                     completion:(GRSNetworkUserInfoCompletionBlock)completion;

/**
 *  Asynchronously purchases a certain quantity of a product. It calls completion either with an NSDictionary containing
 *  the product and its updated quantity or an NSError.
 *
 *  @param name       the name of the product we're trying to purchase
 *  @param quantity   the quantity of the product we're trying to purchase
 *  @param completion the completion handler that gets called when the server call is done
 */
- (void)purchaseProductWithName:(NSString *)name
                       quantity:(NSInteger)quantity
                     completion:(GRSNetworkUserInfoCompletionBlock)completion;

/**
 *  Asynchronously purchases multiple products. Product names should be keys in the NSDictionary and their values
 *  should be the respective quantities to purchase. The method calls completion with either an NSDictionary containing
 *  the products and their updated quantities or an NSError.
 *
 *  @param products   NSDictionary containing a list of products and the desired quantities to purchase.
 *  @param completion the completion handler that gets called when the server call is done
 */
- (void)purchaseProducts:(NSDictionary *)products completion:(GRSNetworkUserInfoCompletionBlock)completion;

@end
