//
//  Product+API_Interaction.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "Product+API_Interaction.h"
#import "VOKCoreDataManager.h"

@implementation Product (API_Interaction)

- (void)purchase:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:self.name completion:^(NSDictionary *userInfo, NSError *error){
        [self completionHelper:userInfo error:error completion:completion];
    }];
}

- (void)purchaseQuantitiy:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:self.name quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
        [self completionHelper:userInfo error:error completion:completion];
    }];
}

- (void)completionHelper:(NSDictionary *)userInfo error:(NSError *)error completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    if (userInfo) {
        self.quantity = (NSNumber *)[userInfo objectForKey:self.name];
        [[VOKCoreDataManager sharedInstance] saveMainContext];
    }
    
    if (completion) {
        completion(error);
    }
}

- (void)incrementInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    [[GRSNetworkAPIUtility sharedUtility] incrementInventoryQuantityForProductWithName:self.name completion:^(NSDictionary *userInfo, NSError *error) {
        [self completionHelper:userInfo error:error completion:completion];
    }];
}

- (void)setInventoryQuantity:(NSInteger)quantity completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    [[GRSNetworkAPIUtility sharedUtility] setInventoryQuantity:quantity toProductWithName:self.name completion:^(NSDictionary *userInfo, NSError *error) {
        [self completionHelper:userInfo error:error completion:completion];
    }];
}

- (void)setNoInventory:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    [[GRSNetworkAPIUtility sharedUtility] removeAllStockForProductWithName:self.name completion:^(NSError *error){
        if (error == nil) {
            self.quantity = @0;
            [[VOKCoreDataManager sharedInstance] saveMainContext];
        }
        
        if (completion) {
            completion(error);
        }
    }];
}

@end
