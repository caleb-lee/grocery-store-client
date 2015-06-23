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

+ (GRSSyncUtility *)sharedUtility
{
    static GRSSyncUtility *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GRSSyncUtility alloc] init];
    });
    
    return _sharedInstance;
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
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error);
            }
            
            return;
        }
        
        NSMutableArray *products = [NSMutableArray arrayWithCapacity:userInfo.count];
        
        for (NSString *productName in userInfo.allKeys) {
            Product *product = [Product productWithNameOrNew:productName];
            product.quantity = [userInfo objectForKey:productName];
            [products addObject:product];
        }
        
        [[VOKCoreDataManager sharedInstance] saveMainContext];
        
        if (completion != nil) {
            completion(products, error);
        }
    }];
}

- (void)fetchProductWithName:(NSString *)name completion:(GRSSyncUtilityCompletionSingleProduct)completion
{
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:name completion:^(NSDictionary *userInfo, NSError *error){
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error);
            }
            return;
        }
        
        Product *product = [Product productWithNameOrNew:name];
        product.quantity = [userInfo objectForKey:name];
        
        [[VOKCoreDataManager sharedInstance] saveMainContext];
        
        if (completion != nil) {
            completion(product, error);
        }
    }];
}

@end
