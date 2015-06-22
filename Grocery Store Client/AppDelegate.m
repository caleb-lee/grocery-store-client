//
//  AppDelegate.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "AppDelegate.h"

#import "VOKCoreDataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up the data model
    [[VOKCoreDataManager sharedInstance] setResource:@"Grocery_Store_Client" database:nil];
    // Access the main managed object context so that it's created
    [[VOKCoreDataManager sharedInstance] managedObjectContext];
    
    return YES;
}

@end
