//
//  GRSNetworkAPIUtility.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "GRSNetworkAPIUtility.h"

#import "GRSHTTPSessionManager.h"

#pragma mark - API paths

static NSString *const UserLoginPath = @"v1/authenticate";
static NSString *const UserRegisterPath = @"v1/user";
static NSString *const CurrentUserFetchPath = @"v1/user";
static NSString *const SpecificUserFetchPathFormat = @"v1/user/%@"; // v1/user/:id
static NSString *const FacebookLoginRegisterPath = @"v1/user/facebook";
static NSString *const RequestPasswordResetPath = @"v1/password-reset/request";
static NSString *const ResetPasswordPath = @"v1/password-reset/confirm";
static NSString *const NotificationRegisterPath = @"v1/push/apn";

static NSString *const APIKeyEmail = @"email";
static NSString *const APIKeyPassword = @"password";
static NSString *const APIKeyUserID = @"id";
static NSString *const APIKeyUserAuthToken = @"token";
static NSString *const APIKeyFacebookID = @"facebook_id";
static NSString *const APIKeyFacebookToken = @"token";
static NSString *const APIKeyPushNotificationToken = @"token";
static NSString *const APIKeyPasswordResetCode = @"code";

#pragma mark - Constants for errors

NSString *const GRSNetworkAPIUtilityErrorDomain = @"GRSNetworkAPIUtilityErrorDomain";

const struct GRSNetworkAPIUtilityErrorCodes GRSNetworkAPIUtilityErrorCodes = {
    .UnexpectedResponseType = 300001,
};

const struct GRSNetworkAPIUtilityErrorInfoKeys GRSNetworkAPIUtilityErrorInfoKeys = {
    .ReceivedResponseType = @"Received response type",
};

#pragma mark - Class implementation

@implementation GRSNetworkAPIUtility

+ (instancetype)sharedUtility
{
    static GRSNetworkAPIUtility *_sharedUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtility = [GRSNetworkAPIUtility new];
    });
    return _sharedUtility;
}

- (void)registerWithEmailAddress:(NSString *)email
                        password:(NSString *)password
                      completion:(GRSUserInfoCompletionBlock)completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSDictionary *userInfo = @{
                               APIKeyEmail: email ?: @"",
                               APIKeyPassword: password ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:UserRegisterPath
                           withDetails:userInfo
                            completion:completion];
}

- (void)loginWithEmailAddress:(NSString *)email
                     password:(NSString *)password
                   completion:(GRSUserInfoCompletionBlock)completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSDictionary *userInfo = @{
                               APIKeyEmail: email ?: @"",
                               APIKeyPassword: password ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:UserLoginPath
                           withDetails:userInfo
                            completion:completion];
}

- (void)loginOrRegisterFacebookUserID:(NSString *)facebookID
                        facebookToken:(NSString *)facebookToken
                           completion:(GRSUserInfoCompletionBlock)completion
{
    NSParameterAssert(facebookID);
    NSParameterAssert(facebookToken);
    NSDictionary *userInfo = @{
                               APIKeyFacebookID: facebookID ?: @"",
                               APIKeyFacebookToken: facebookToken ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:FacebookLoginRegisterPath
                           withDetails:userInfo
                            completion:completion];
}

- (void)fetchCurrentUserWithCompletion:(GRSUserInfoCompletionBlock)completion
{
    [[GRSHTTPSessionManager sharedManager] GET:CurrentUserFetchPath
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                               if (completion) {
                                                   completion(responseObject, nil);
                                               }
                                           } else if (completion) {
                                               completion(nil, [self unexpectedResponseTypeErrorForClass:[responseObject class]]);
                                           }
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           if (completion) {
                                               completion(nil, error);
                                           }
                                       }];
}

- (void)requestPasswordResetForEmail:(NSString *)email
                          completion:(GRSNoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(email);

    NSDictionary *parameters = @{APIKeyEmail: email ?: @""};

    [[GRSHTTPSessionManager sharedManager] POST:RequestPasswordResetPath
                                     parameters:parameters
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            if (completion) {
                                                completion(nil);
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            if (completion) {
                                                completion(error);
                                            }
                                        }];
}

- (void)resetPassword:(NSString *)newPassword
            usingCode:(NSString *)resetCode
           completion:(GRSNoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(newPassword);
    NSParameterAssert(resetCode);
    
    NSDictionary *parameters = @{
                                 APIKeyPassword: newPassword ?: @"",
                                 APIKeyPasswordResetCode: resetCode ?: @"",
                                 };
    
    [[GRSHTTPSessionManager sharedManager] POST:ResetPasswordPath
                                     parameters:parameters
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            if (completion) {
                                                completion(nil);
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            if (completion) {
                                                completion(error);
                                            }
                                        }];
}

- (void)registerForNotificationsWithDeviceToken:(NSData *)deviceToken
                                     completion:(GRSNoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(deviceToken);

    // Convert NSData device token to NSString token
    NSString *stringToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSDictionary *parameters = @{APIKeyPushNotificationToken: stringToken ?: @""};

    [[GRSHTTPSessionManager sharedManager] POST:NotificationRegisterPath
                                     parameters:parameters
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            if (completion) {
                                                completion(nil);
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            if (completion) {
                                                completion(error);
                                            }
                                        }];
}

- (void)getUserWithID:(NSInteger)userID
           completion:(GRSUserInfoCompletionBlock)completion
{
    NSParameterAssert(userID > 0);
    NSString *userFetchPath = [NSString stringWithFormat:SpecificUserFetchPathFormat, @(userID)];

    [[GRSHTTPSessionManager sharedManager] GET:userFetchPath
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                               if (completion) {
                                                   completion(responseObject, nil);
                                               }
                                           } else if (completion) {
                                               completion(nil, [self unexpectedResponseTypeErrorForClass:[responseObject class]]);
                                           }
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           if (completion) {
                                               completion(nil, error);
                                           }
                                       }];
}

#pragma mark - Private helpers

/**
 * Since the register and login endpoints take (roughly) the same parameters and
 * return the same kind of response, and in both cases the authorization token
 * needs to be saved, this helper method handles both actions by taking the path
 * against which the operation should be executed.
 */
- (void)executeLoginOrRegisterOnPath:(NSString *)path
                         withDetails:(NSDictionary *)loginDetails
                          completion:(GRSUserInfoCompletionBlock)completion
{
    NSParameterAssert(path);
    NSParameterAssert(loginDetails);

    [[GRSHTTPSessionManager sharedManager] POST:path
                                     parameters:loginDetails
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                // Store the authorization token for future API calls
                                                NSString *authorizationToken = responseObject[APIKeyUserAuthToken];
                                                [GRSHTTPSessionManager setAuthorizationToken:authorizationToken];

                                                if (completion) {
                                                    completion(responseObject, nil);
                                                }
                                            } else if (completion) {
                                                completion(nil, [self unexpectedResponseTypeErrorForClass:[responseObject class]]);
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            if (completion) {
                                                completion(nil, error);
                                            }
                                        }];
}

- (NSError *)unexpectedResponseTypeErrorForClass:(Class)class
{
    return [NSError errorWithDomain:GRSNetworkAPIUtilityErrorDomain
                               code:GRSNetworkAPIUtilityErrorCodes.UnexpectedResponseType
                           userInfo:@{GRSNetworkAPIUtilityErrorInfoKeys.ReceivedResponseType: NSStringFromClass(class)}];
}

@end
