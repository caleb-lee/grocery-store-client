//
//  GRSNetworkAPIUtility.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Completion block definitions

/// Completion block for register and login actions. userInfo is set on success, nil on failure.
typedef void(^GRSUserInfoCompletionBlock)(NSDictionary *userInfo, NSError *error);

/// Completion block for API endpoints that don't return any response body.
typedef void(^GRSNoResponseNetworkCompletionBlock)(NSError *error);

#pragma mark - Constants for errors

FOUNDATION_EXPORT NSString *const GRSNetworkAPIUtilityErrorDomain;

FOUNDATION_EXPORT const struct GRSNetworkAPIUtilityErrorCodes
{
    NSInteger UnexpectedResponseType;
} GRSNetworkAPIUtilityErrorCodes;

FOUNDATION_EXPORT const struct GRSNetworkAPIUtilityErrorInfoKeys
{
    __unsafe_unretained NSString *ReceivedResponseType;
} GRSNetworkAPIUtilityErrorInfoKeys;

#pragma mark - Class header

@interface GRSNetworkAPIUtility : NSObject

+ (instancetype)sharedUtility;

- (void)registerWithEmailAddress:(NSString *)email
                        password:(NSString *)password
                      completion:(GRSUserInfoCompletionBlock)completion;

- (void)loginWithEmailAddress:(NSString *)email
                     password:(NSString *)password
                   completion:(GRSUserInfoCompletionBlock)completion;

- (void)loginOrRegisterFacebookUserID:(NSString *)facebookID
                        facebookToken:(NSString *)facebookToken
                           completion:(GRSUserInfoCompletionBlock)completion;

- (void)fetchCurrentUserWithCompletion:(GRSUserInfoCompletionBlock)completion;

- (void)requestPasswordResetForEmail:(NSString *)email
                          completion:(GRSNoResponseNetworkCompletionBlock)completion;

- (void)resetPassword:(NSString *)newPassword
            usingCode:(NSString *)resetCode
           completion:(GRSNoResponseNetworkCompletionBlock)completion;

- (void)registerForNotificationsWithDeviceToken:(NSData *)deviceToken
                                     completion:(GRSNoResponseNetworkCompletionBlock)completion;

- (void)getUserWithID:(NSInteger)userID
           completion:(GRSUserInfoCompletionBlock)completion;

@end
