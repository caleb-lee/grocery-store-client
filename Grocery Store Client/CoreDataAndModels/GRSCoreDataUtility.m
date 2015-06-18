//
//  GRSCoreDataUtility.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSCoreDataUtility.h"

#import "VOKCoreDataManager.h"

@implementation GRSCoreDataUtility

+ (void)setupCoreDataForTesting
{
    [self setupCoreDataWithDatabaseName:nil];
}

+ (void)setupCoreData
{
    [self setupCoreDataWithDatabaseName:@"Grocery_Store_Client.sqlite"];
}

+ (void)nukeAndResetCoreData
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setupCoreData];
}

+ (void)nukeAndResetCoreDataForTesting
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setupCoreDataForTesting];
}

+ (void)setupCoreDataWithDatabaseName:(NSString *)databaseName
{
    //Setup Core Data Stack
    [self setupCoreDataStackWithDatabaseName:databaseName];

    //Setup Object Mappers
    [self setupObjectMappers];
}

+ (void)setupCoreDataStackWithDatabaseName:(NSString *)databaseName
{
    //Model Setup
    [[VOKCoreDataManager sharedInstance] setResource:@"Grocery_Store_Client" database:databaseName];

    //Fire Up Context
    [[VOKCoreDataManager sharedInstance] managedObjectContext];
}

#pragma mark - Mappers

+ (void)setupObjectMappers
{
    //TODO:Fire Off Your Mapper Methods Here
}

@end
