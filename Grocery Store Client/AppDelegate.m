//
//  AppDelegate.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "AppDelegate.h"

#import "GRSSyncUtility.h"
#import "GRSCoreDataUtility.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up Core Data
    [GRSCoreDataUtility setupCoreData];
    
    // First sync of data from the server
    [[GRSSyncUtility sharedUtility] downSync:nil];
    
    return YES;
}

@end
