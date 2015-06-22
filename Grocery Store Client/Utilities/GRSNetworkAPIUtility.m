//
//  GRSNetworkAPIUtility.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSNetworkAPIUtility.h"

#import "AFNetworking.h"

static NSString *const BaseURLString = @"http://127.0.0.1:4567/api/";

@interface GRSNetworkAPIUtility ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation GRSNetworkAPIUtility

+ (GRSNetworkAPIUtility *)sharedUtility
{
    static GRSNetworkAPIUtility *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GRSNetworkAPIUtility alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        // set up the AFHTTPRequestOperationManager
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)fetchProductInventory:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *const path = @"inventory";
    [self fetchProductsHelperMethod:path completion:completion];
}

- (void)fetchProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"inventory/%@", name];
    [self fetchProductsHelperMethod:path completion:completion];
}

- (void)fetchProductsHelperMethod:(NSString *)path completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    [self.manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = (NSDictionary *)responseObject;
        
        if (completion != nil) {
            completion(userInfo, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)incrementInventoryQuantityForProductWithName:(NSString *)name
                                          completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"inventory/%@", name];
    
    [self.manager POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = (NSDictionary *)responseObject;
        
        if (completion != nil) {
            completion(userInfo, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)setInventoryQuantity:(NSInteger)quantity
           toProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    
}

- (void)removeAllStockForProductWithName:(NSString *)name
                              completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    
}

- (void)purchaseProductWithName:(NSString *)name
                     completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    
}

- (void)purchaseProductWithName:(NSString *)name
                       quantity:(NSInteger)quantity
                     completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    
}

@end
