//
//  GRSNetworkAPIUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

// --> typedefs taken from Vokal's URLNetworkAPIUtility
/// Completion block for register and login actions. userInfo is set on success, nil on failure.
typedef void(^GRSNetworkUserInfoCompletionBlock)(NSDictionary *userInfo, NSError *error);
/// Completion block for API endpoints that don't return any response body.
typedef void(^GRSNetworkNoResponseNetworkCompletionBlock)(NSError *error);

@interface GRSNetworkAPIUtility : NSObject

+ (GRSNetworkAPIUtility *)sharedUtility;

- (void)fetchProductInventory:(GRSNetworkUserInfoCompletionBlock)completion;
- (void)fetchProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion;
- (void)incrementInventoryQuantityForProductWithName:(NSString *)name
                                          completion:(GRSNetworkUserInfoCompletionBlock)completion;
- (void)setInventoryQuantity:(NSInteger)quantity
           toProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion;
- (void)removeAllStockForProductWithName:(NSString *)name
                              completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion;
- (void)purchaseProductWithName:(NSString *)name
                     completion:(GRSNetworkUserInfoCompletionBlock)completion;
- (void)purchaseProductWithName:(NSString *)name
                       quantity:(NSInteger)quantity
                     completion:(GRSNetworkUserInfoCompletionBlock)completion;

@end
