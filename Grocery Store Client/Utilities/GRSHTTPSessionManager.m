//
//  GRSHTTPSessionManager.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

// Un-comment this line to see full network traffic logging for debugging
// #define USE_NETWORKING_DEBUG_LOGGING 1

#import "GRSHTTPSessionManager.h"

//TODO: modify the following environment configuration mechanism as necessary:
//Whether to use the production environment/server.
//Uncomment this line to use production or define PRODUCTION_ENVIRONMENT in another place
//#define PRODUCTION_ENVIRONMENT 1

/**
 * TODO: replace these URLs with the actual staging and production API URLs.
 * The URLs should NOT include the trailing slash, but may include subpaths. For
 * example, this would be a valid value:
 *   https://api-staging.example.com/api
 */
#ifndef PRODUCTION_ENVIRONMENT
// Staging API
static NSString *const APIBaseURL = @"https://api-staging.example.com";
#else
// Production API
static NSString *const APIBaseURL = @"https://api.example.com";
#endif

@implementation GRSHTTPSessionManager

static GRSHTTPSessionManager *_sharedManager;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self resetSharedManagerWithSessionConfiguration:nil];
    });
    return _sharedManager;
}

+ (BOOL)useProductionEnvironment
{
#ifdef PRODUCTION_ENVIRONMENT
    return YES;
#else
    return NO;
#endif
}

+ (void)setAuthorizationToken:(NSString *)authToken
{
    NSDictionary *additionalHeaders;
    if (authToken) {
        additionalHeaders = @{@"Authorization": authToken};
    }
    GRSHTTPSessionManager *sessionManager = [self sharedManager];
    sessionManager.session.configuration.HTTPAdditionalHeaders = additionalHeaders;
}

+ (void)resetSharedManagerWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    _sharedManager = [[GRSHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]
                                               sessionConfiguration:sessionConfiguration];
    _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
}

// Override the data task completion handler to add debug logging
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    return [super dataTaskWithRequest:request
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
#ifdef USE_NETWORKING_DEBUG_LOGGING
                        // Debug logging
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        DLog(@"Response:\nCode %@ %@ %@\nRequest body:\n%@\nResponse body:\n%@\nError: %@",
                             @(httpResponse.statusCode),
                             request.HTTPMethod,
                             request.URL.absoluteString,
                             [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],
                             responseObject,
                             error);
#endif

                        if (completionHandler) {
                            completionHandler(response, responseObject, error);
                        }
                    }];
}

@end
