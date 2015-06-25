//
//  GRSSyncUtility.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSSyncUtility.h"

#import "GRSNetworkAPIUtility.h"
#import "Product+GRSFindOrCreateNew.h"
#import "VOKCoreDataManager.h"

@implementation GRSSyncUtility

+ (instancetype)sharedUtility
{
    static GRSSyncUtility *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GRSSyncUtility alloc] init];
    });
    
    return sharedInstance;
}

- (void)downSync:(GRSSyncUtilityCompletionNoProducts)completion
{
    [self fetchProductInventory:^(NSArray *products, NSError *error) {
        if (completion != nil) {
            completion(error);
        }
    }];
}

- (void)fetchProductInventory:(GRSSyncUtilityCompletionMultipleProducts)completion
{
    [[GRSNetworkAPIUtility sharedUtility] fetchProductInventory:^(NSDictionary *userInfo, NSError *error){
        if (![self handleError:error withCompletion:completion]) {
            NSMutableArray *products = [NSMutableArray arrayWithCapacity:userInfo.count];
            
            // add and update products from the server
            for (NSString *productName in userInfo.allKeys) {
                Product *product = [Product productWithNameOrNew:productName];
                product.quantity = [userInfo objectForKey:productName];
                [products addObject:product];
            }
            
            // remove any products that no longer exist on the server
            NSArray *localProducts = [[VOKCoreDataManager sharedInstance] arrayForClass:[Product class]];
            for (Product *product in localProducts) {
                NSNumber *quantity = [userInfo objectForKey:product.name];
                
                if (quantity == nil) {
                    [[VOKCoreDataManager sharedInstance] deleteObject:product];
                }
            }
            
            [[VOKCoreDataManager sharedInstance] saveMainContext];
            
            if (completion != nil) {
                completion(products, error);
            }
        }
    }];
}

- (void)fetchProductWithName:(NSString *)name completion:(GRSSyncUtilityCompletionSingleProduct)completion
{
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:name completion:^(NSDictionary *userInfo, NSError *error){
        if (![self handleError:error withCompletion:completion]) {
            Product *product = [Product productWithNameOrNew:name];
            product.quantity = [userInfo objectForKey:name];
            
            [[VOKCoreDataManager sharedInstance] saveMainContext];
            
            if (completion != nil) {
                completion(product, error);
            }
        }
    }];
}

- (BOOL)handleError:(NSError *)error withCompletion:(void (^)(id returnedObject, NSError *error))completion
{
    if (error != nil) {
        if (completion != nil) {
            completion(nil, error);
        }
    }
    
    return error != nil;
}

@end
