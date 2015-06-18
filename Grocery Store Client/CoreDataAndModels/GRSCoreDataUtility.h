//
//  GRSCoreDataUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRSCoreDataUtility : NSObject

/**
 * Sets up the maps to use an in-memory store for testing.
 */
+ (void)setupCoreDataForTesting;

/**
 * Standard setup method.
 */
+ (void)setupCoreData;

/**
 *  Nukes the existing store and sets it back up as a clean store.
 */
+ (void)nukeAndResetCoreData;

/**
 *  Nukes the existing store and sets it back up as a clean store for testing.
 */
+ (void)nukeAndResetCoreDataForTesting;

@end
