//
//  Grocery_Store_ClientTests.m
//  Grocery Store ClientTests
//
//  Created by Caleb Lee on 2015/06/18.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GRSNetworkAPIUtility.h"

@interface Grocery_Store_ClientTests : XCTestCase

@end

@implementation Grocery_Store_ClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testFetchProductInventory
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test fetch full inventory"];
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductInventory:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 4, @"There should be four keys in userInfo");
        XCTAssertNotNil([userInfo objectForKey:@"oranges"], "Oranges should be in the inventory");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testFetchProductInventoryWithNameSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test fetch inventory for single product (success)"];
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:@"oranges" completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
        XCTAssertNotNil([userInfo objectForKey:@"oranges"], "Oranges should be in the inventory");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testFetchProductInventoryWithNameFailure
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test fetch inventory for single product (failure)"];
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:@"applessss" completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSDictionary *errorInfo = error.userInfo;
        NSHTTPURLResponse *response = [errorInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        XCTAssertEqual(response.statusCode, 404, @"Status code should be 404");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testIncrementInventoryQuantity
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test increment inventory quantity"];
    
    NSString *const itemName = @"eggs";
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        NSNumber *originalInventory = [userInfo objectForKey:itemName];
        
        [[GRSNetworkAPIUtility sharedUtility] incrementInventoryQuantityForProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
            XCTAssertNil(error, @"error should be set to nil");
            XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
            XCTAssertEqual(originalInventory.integerValue + 1, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal original inventory plus one");
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testSetInventoryQuantitySuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test set inventory quantity success"];
    
    NSString *const itemName = @"milk";
    
    [[GRSNetworkAPIUtility sharedUtility] setInventoryQuantity:50 toProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
        XCTAssertEqual(50, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal 50");
            
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testSetInventoryQuantityFailureNegativeValue
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test set inventory quantity success"];
    
    NSString *const itemName = @"milk";
    
    [[GRSNetworkAPIUtility sharedUtility] setInventoryQuantity:-50 toProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSDictionary *errorInfo = error.userInfo;
        NSHTTPURLResponse *response = [errorInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
