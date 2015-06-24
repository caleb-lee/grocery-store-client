//
//  GRSNetworkAPIUtility.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSNetworkAPIUtility.h"

#import "GRSHTTPSessionManager.h"

static NSString *const InventoryPath = @"inventory";
static NSString *const PurchasePath = @"purchase";
static NSString *const QuantityKey = @"quantity";

@interface GRSNetworkAPIUtility ()

@property (strong, nonatomic) GRSHTTPSessionManager *manager;

@end

@implementation GRSNetworkAPIUtility

+ (instancetype)sharedUtility
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
        self.manager = [GRSHTTPSessionManager sharedManager];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)fetchProductInventory:(GRSNetworkUserInfoCompletionBlock)completion
{
    [self GETHelperMethod:InventoryPath completion:completion];
}

- (void)fetchProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [self buildInventoryPathStringForItemNamed:name];
    [self GETHelperMethod:path completion:completion];
}

- (void)incrementInventoryQuantityForProductWithName:(NSString *)name
                                          completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [self buildInventoryPathStringForItemNamed:name];
    [self POSTHelperMethod:path params:nil completion:completion];
}

- (void)setInventoryQuantity:(NSInteger)quantity
           toProductWithName:(NSString *)name
                  completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [self buildInventoryPathStringForItemNamed:name];
    NSDictionary *params = [self buildQuantityParamsDictionary:quantity];
    [self POSTHelperMethod:path params:params completion:completion];
}

- (void)removeAllStockForProductWithName:(NSString *)name
                              completion:(GRSNetworkNoResponseNetworkCompletionBlock)completion
{
    NSString *path = [self buildInventoryPathStringForItemNamed:name];
    
    [self.manager DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion != nil) {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion != nil) {
            completion(error);
        }
    }];
}

- (void)purchaseProductWithName:(NSString *)name
                     completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [self buildPurhcasePathStringForItemNamed:name];
    [self POSTHelperMethod:path params:nil completion:completion];
}

- (void)purchaseProductWithName:(NSString *)name
                       quantity:(NSInteger)quantity
                     completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    NSString *path = [self buildPurhcasePathStringForItemNamed:name];
    NSDictionary *params = [self buildQuantityParamsDictionary:quantity];
    [self POSTHelperMethod:path params:params completion:completion];
}

- (void)purchaseProducts:(NSDictionary *)products completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    [self POSTHelperMethod:PurchasePath params:products completion:completion];
}

- (void)GETHelperMethod:(NSString *)path completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    [self.manager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *userInfo = (NSDictionary *)responseObject;
        
        if (completion != nil) {
            completion(userInfo, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)POSTHelperMethod:(NSString *)path params:(NSDictionary *)paramsOrNil completion:(GRSNetworkUserInfoCompletionBlock)completion
{
    [self.manager POST:path parameters:paramsOrNil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *userInfo = (NSDictionary *)responseObject;
        
        if (completion != nil) {
            completion(userInfo, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (NSDictionary *)buildQuantityParamsDictionary:(NSInteger)quantity
{
    return @{QuantityKey: @(quantity)};
}

- (NSString *)buildInventoryPathStringForItemNamed:(NSString *)name
{
    return [NSString stringWithFormat:@"%@/%@", InventoryPath, name];
}

- (NSString *)buildPurhcasePathStringForItemNamed:(NSString *)name
{
    return [NSString stringWithFormat:@"%@/%@", PurchasePath, name];
}

@end
