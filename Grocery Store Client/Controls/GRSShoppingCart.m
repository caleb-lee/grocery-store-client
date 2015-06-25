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
    static GRSShoppingCart *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GRSShoppingCart alloc] init];
    });
    
    return sharedInstance;
}

- (void)addProductToCart:(Product *)product quantity:(NSInteger)quantity
{
    self.productsInCart[product.name] = @(quantity);
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
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        
        NSMutableArray *productsArray = [[NSMutableArray alloc] initWithCapacity:userInfo.count];
        
        [userInfo enumerateKeysAndObjectsUsingBlock:^(NSString *productName, NSNumber *quantity, BOOL *stop){
            Product *product = [Product productWithNameOrNew:productName];
            
            product.quantity = quantity;
            
            [productsArray addObject:product];
            [self.productsInCart removeObjectForKey:productName];
        }];
        
        if (userInfo.count > 0) {
            [[VOKCoreDataManager sharedInstance] saveMainContext];
        }
        
        if (completion) {
            completion(productsArray, nil);
        }
    }];
}

@end
