//
//  GRSShoppingCart.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/24.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

typedef void(^GRSShoppingCartPurchaseCompletion)(NSArray *products, NSError *error);

/**
 *  GRSShoppingCart keeps track of products waiting to be purchased and purchases them
 *  upon user command.
 */
@interface GRSShoppingCart : NSObject

/**
 *  GRSShoppingCart is a singleton. This returns the singleton instance.
 *
 *  @return the shared shopping cart
 */
+ (instancetype)sharedInstance;

/**
 *  A dictionary of all the products in the shopping cart. Keys are product names; 
 *  values are the desired quantity in NSNumber format.
 */
@property (strong, readonly, nonatomic) NSMutableDictionary *productsInCart;

/**
 *  Adds a product and the desired purchased quantity to the shopping cart. If the product
 *  is already in the cart, the quantity will simply get updated.
 *
 *  @param product  the product to purchase
 *  @param quantity the quantity to purchase
 */
- (void)addProductToCart:(Product *)product quantity:(NSInteger)quantity;

 /**
 *  Removes a given product from the cart. Does nothing if no product of that name exists.
 *
 *  @param product the product the user wants to remove
 */
- (void)removeProductFromCart:(Product *)product;

/**
 *  Sends the call to the server to purchase all the products in the cart at the quantites
 *  specified.
 *
 *  @param completion the completion handler that is called after the API call completes
 */
- (void)purchaseProductsInCart:(GRSShoppingCartPurchaseCompletion)completion;

@end
