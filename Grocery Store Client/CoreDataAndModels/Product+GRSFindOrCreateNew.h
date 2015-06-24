//
//  Product+GRSFindOrCreateNew.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/23.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "Product.h"

@interface Product (GRSFindOrCreateNew)

/**
 *  Finds the product in the database with a certain name and returns it.
 *  If no such product exists, one gets created and returned.
 *
 *  @param name the name of the product we're trying to find; the name used
 *          to create the product if not found
 *
 *  @return the found/created product
 */
+ (Product *)productWithNameOrNew:(NSString *)name;

@end
