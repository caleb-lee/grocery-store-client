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

- (void)testSetInventoryToZero
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test set inventory to zero"];
    
    NSString *const itemName = @"milk";
    
    [[GRSNetworkAPIUtility sharedUtility] removeAllStockForProductWithName:itemName completion:^(NSError *error) {
        XCTAssertNil(error, @"error should be nil");
        
        [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
            NSInteger quantity = ((NSNumber *)[userInfo objectForKey:itemName]).integerValue;
            XCTAssertEqual(0, quantity, @"Quantity should be zeroed here");
            
            // test the error case
            [[GRSNetworkAPIUtility sharedUtility] removeAllStockForProductWithName:itemName completion:^(NSError *error) {
                XCTAssertNotNil(error, @"error SHOULD NOT be nil here");
                
                NSDictionary *errorInfo = error.userInfo;
                NSHTTPURLResponse *response = [errorInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
                XCTAssertEqual(response.statusCode, 404, @"Status code should be 404");
                
                // make the item have a quantity again
                [[GRSNetworkAPIUtility sharedUtility] setInventoryQuantity:100 toProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
                    [expectation fulfill];
                }];
            }];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPurchaseOneOfOneItemSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing one of one item"];
    
    NSString *const itemName = @"apples";
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        NSNumber *originalInventory = [userInfo objectForKey:itemName];
        
        [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
            XCTAssertNil(error, @"error should be set to nil");
            XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
            XCTAssertEqual(originalInventory.integerValue - 1, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal original inventory minus one");
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPurchaseMultipleOfOneItemSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple of one item"];
    
    NSString *const itemName = @"apples";
    NSInteger quantity = 5;
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        NSNumber *originalInventory = [userInfo objectForKey:itemName];
        
        [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
            XCTAssertNil(error, @"error should be set to nil");
            XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
            XCTAssertEqual(originalInventory.integerValue - quantity, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal original inventory minus %ld", quantity);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
