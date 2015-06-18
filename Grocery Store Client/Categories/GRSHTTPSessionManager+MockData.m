//
//  GRSHTTPSessionManager+MockData.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSHTTPSessionManager+MockData.h"

#import "VOKMockUrlProtocol.h"

@implementation GRSHTTPSessionManager (MockData)

+ (void)switchToMockData
{
    NSURLSessionConfiguration *sessionConfiguration = [GRSHTTPSessionManager sharedManager].session.configuration;

    Class mockURLProtocol = [VOKMockUrlProtocol class];
    NSMutableArray *currentProtocolClasses = [sessionConfiguration.protocolClasses mutableCopy];
    [currentProtocolClasses insertObject:mockURLProtocol atIndex:0];
    sessionConfiguration.protocolClasses = currentProtocolClasses;

    [GRSHTTPSessionManager resetSharedManagerWithSessionConfiguration:sessionConfiguration];
}

+ (void)switchToLiveNetwork
{
    NSURLSessionConfiguration *sessionConfiguration = [GRSHTTPSessionManager sharedManager].session.configuration;

    Class mockURLProtocol = [VOKMockUrlProtocol class];
    NSMutableArray *currentProtocolClasses = [sessionConfiguration.protocolClasses mutableCopy];
    [currentProtocolClasses removeObject:mockURLProtocol];
    sessionConfiguration.protocolClasses = currentProtocolClasses;

    [GRSHTTPSessionManager resetSharedManagerWithSessionConfiguration:sessionConfiguration];
}

@end
