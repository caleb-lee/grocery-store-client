//
//  GRSSyncUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/22.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Product.h"

typedef void(^GRSSyncUtilityCompletionNoProducts)(NSError *error);
typedef void(^GRSSyncUtilityCompletionSingleProduct)(Product *product, NSError *error);
typedef void(^GRSSyncUtilityCompletionMultipleProducts)(NSArray *products, NSError *error);

@interface GRSSyncUtility : NSObject

+ (GRSSyncUtility *)sharedUtility;

- (void)downSync:(GRSSyncUtilityCompletionNoProducts)completion;

- (void)fetchProductInventory:(GRSSyncUtilityCompletionMultipleProducts)completion;
- (void)fetchProductWithName:(NSString *)name completion:(GRSSyncUtilityCompletionSingleProduct)completion;

@end
