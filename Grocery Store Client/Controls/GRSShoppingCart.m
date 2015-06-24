//
//  GRSShoppingCart.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/24.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSShoppingCart.h"

#import "GRSNetworkAPIUtility.h"
#import "Product+GRSFindOrCreateNew.h"
#import "VOKCoreDataManager.h"

@interface GRSShoppingCart ()

@property (strong, readwrite, nonatomic) NSMutableDictionary *productsInCart;

@end

@implementation GRSShoppingCart

- (id)init
{
    if (self = [super init]) {
        self.productsInCart = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static GRSShoppingCart *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GRSShoppingCart alloc] init];
    });
    
    return _sharedInstance;
}

- (void)addProductToCart:(Product *)product quantity:(NSInteger)quantity
{
    [self.productsInCart setObject:@(quantity) forKey:product.name];
}

- (void)removeProductFromCart:(Product *)product
{
    [self removeProductWithNameFromCart:product.name];
}

- (void)removeProductWithNameFromCart:(NSString *)productName
{
    [self.productsInCart removeObjectForKey:productName];
}

- (void)purchaseProductsInCart:(GRSShoppingCartPurchaseCompletion)completion
{
    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:self.productsInCart completion:^(NSDictionary *userInfo, NSError *error){
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error);
            }
            
            return;
        }
        
        NSMutableArray *productsArray = [[NSMutableArray alloc] initWithCapacity:userInfo.count];
        for (NSString *productName in userInfo.allKeys) {
            Product *product = [Product productWithNameOrNew:productName];
            
            product.quantity = [userInfo objectForKey:productName];
            
            [productsArray addObject:product];
            [self.productsInCart removeObjectForKey:productName];
        }
        
        [[VOKCoreDataManager sharedInstance] saveMainContext];
        
        if (completion != nil) {
            completion(productsArray, nil);
        }
    }];
}

@end
