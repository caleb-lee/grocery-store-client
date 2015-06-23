//
//  GRSSyncUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

/**
 *  GRSSyncUtility takes care of downloading data from the server and syncing
 *  with local data on the phone. It is a singleton class and therefore its
 *  instance can be accessed from anywhere in the app.
 */

#import <Foundation/Foundation.h>

#import "Product.h"

typedef void(^GRSSyncUtilityCompletionNoProducts)(NSError *error);
typedef void(^GRSSyncUtilityCompletionSingleProduct)(Product *product, NSError *error);
typedef void(^GRSSyncUtilityCompletionMultipleProducts)(NSArray *products, NSError *error);

@interface GRSSyncUtility : NSObject

/**
 *  Returns the shared instance of GRSSyncUtility.
 *
 *  @return the shared instance
 */
+ (GRSSyncUtility *)sharedUtility;

/**
 *  Asynchronously downloads all inventory data from the server and
 *  stores in core data. It will create new Products for names that
 *  don't already exist in the database as well as update the ones 
 *  that do. Completion is called when the sync is complete; NSError
 *  will only be non-nil if not successful.
 *
 *  @param completion the completion handler that is called when the sync is complete
 */
- (void)downSync:(GRSSyncUtilityCompletionNoProducts)completion;

/**
 *  Asynchronously downloads all inventory from the server, stores
 *  in core data, and (via the completion handler) returns an NSArray
 *  containing Product instances for every item. Completion is called
 *  when the sync is complete. NSError will be non-nil if not successful.
 *
 *  @param completion the completion handler that is called when the sync is complete
 */
- (void)fetchProductInventory:(GRSSyncUtilityCompletionMultipleProducts)completion;

/**
 *  Asynchronously downloads the data for the product with the name and returns its
 *  Product instance via the completion handler. It will also update the Core Data
 *  entry or create a new one if needed. NSError will be non-nil if not successful.
 *
 *  @param name     the name of the Product we are trying to fetch
 *  @param completion   the completion block that gets called at the end of fetch/sync
 */
- (void)fetchProductWithName:(NSString *)name completion:(GRSSyncUtilityCompletionSingleProduct)completion;

@end
