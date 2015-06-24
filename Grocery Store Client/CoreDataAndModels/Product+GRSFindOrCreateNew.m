//
//  Product+GRSFindOrCreateNew.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/23.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "Product+GRSFindOrCreateNew.h"
#import "VOKCoreDataManager.h"

@implementation Product (GRSFindOrCreateNew)

+ (Product *)productWithNameOrNew:(NSString *)name
{
    Product *product = nil;
    
    NSPredicate *productWithName = [NSPredicate predicateWithFormat:@"%K == %@", VOK_CDSELECTOR(name), name];
    
    if ([self vok_existsForPredicate:productWithName forManagedObjectContext:nil]) {
        product = [self vok_fetchForPredicate:productWithName forManagedObjectContext:nil];
    } else {
        product = [self vok_newInstance];
        product.name = name;
        [[VOKCoreDataManager sharedInstance] saveMainContext];
    }
    
    return product;
}

@end
