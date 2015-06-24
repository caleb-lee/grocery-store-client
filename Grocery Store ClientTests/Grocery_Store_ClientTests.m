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
#import "GRSHTTPSessionManager+MockData.h"

static const NSInteger TimeoutOneNetworkConnection = 2;
static NSString *const AFNetworkingErrorURLResponseKey = @"com.alamofire.serialization.response.error.response";
static NSString *const AFNetworkingErrorResponseDataKey = @"com.alamofire.serialization.response.error.data";

static NSString *const ErrorJSONKey = @"error";

@interface Grocery_Store_ClientTests : XCTestCase

@end

@implementation Grocery_Store_ClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [GRSHTTPSessionManager switchToMockData];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [GRSHTTPSessionManager switchToLiveNetwork];
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
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testFetchProductInventoryWithNameFailure
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test fetch inventory for single product (failure)"];
    
    [[GRSNetworkAPIUtility sharedUtility] fetchProductWithName:@"applessss" completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 404, @"Status code should be 404");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testIncrementInventoryQuantity
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test increment inventory quantity"];
    
    NSString *const itemName = @"eggs";
    
    [[GRSNetworkAPIUtility sharedUtility] incrementInventoryQuantityForProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
        XCTAssertEqual(23, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory for eggs should be 23");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testSetInventoryQuantityFailureNegativeValue
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test set inventory failure negative value"];
    
    NSString *const itemName = @"milk";
    
    [[GRSNetworkAPIUtility sharedUtility] setInventoryQuantity:-50 toProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Quantity must be positive.");
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
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
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseOneOfOneItemSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing one of one item"];
    
    NSString *const itemName = @"apples";
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
        XCTAssertEqual(122, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal 122");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseOneItemFailureNoStock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing one of one item and having it fail because of no stock"];
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:@"eggs" completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 404, @"Status code should be 404");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Product eggs is not available.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseOneItemFailureWrongItem
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing one of one item and having it fail because the item name doesn't exist"];
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:@"egggs" completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"No product with the name egggs exists.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleOfOneItemSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple of one item"];
    
    NSString *const itemName = @"apples";
    NSInteger const quantity = 5;
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error, @"error should be set to nil");
        XCTAssertEqual(userInfo.count, 1, @"There should be one key in userInfo");
        XCTAssertEqual(118, ((NSNumber *)[userInfo objectForKey:itemName]).integerValue, @"New inventory should equal 118");
        
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleOfOneItemFailureNegativeQuantity
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple of one item; fails because of negative quantity"];
    
    NSString *const itemName = @"apples";
    NSInteger const quantity = -5;
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Cannot purchase less than one of something.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleOfOneItemFailureTooLittleStock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple of one item; fails because of too little stock"];
    
    NSString *const itemName = @"apples";
    NSInteger const quantity = 5000;
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Not enough stock to make purchase.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleOfOneItemFailureWrongName
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple of one item; fails because name doesn't exist"];
    
    NSString *const itemName = @"appples";
    NSInteger const quantity = 5000;
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProductWithName:itemName quantity:quantity completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"No product with the name appples exists.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleItemsSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple items success"];
    
    NSString *const apples = @"apples";
    NSString *const eggs = @"eggs";
    NSDictionary *products = @{eggs: @10, apples: @5};

    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:products completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(error);
        XCTAssertEqual(userInfo.count, 2);
        
        NSNumber *newAppleQuantity = [userInfo objectForKey:apples];
        NSNumber *newEggQuantity = [userInfo objectForKey:eggs];
        
        XCTAssertEqualObjects(@12, newEggQuantity);
        XCTAssertEqualObjects(@118, newAppleQuantity);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleItemsFailureWrongName
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple items failure wrong name"];
    
    NSString *const apples = @"apples";
    NSString *const eggs = @"egggs";
    NSDictionary *products = @{eggs: @10, apples: @5};
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:products completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"No product with the name egggs exists.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleItemsFailureNegativeQuantity
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple items failure negative quantity"];
    
    NSString *const apples = @"apples";
    NSString *const eggs = @"eggs";
    NSDictionary *products = @{eggs: @10, apples: @-5};
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:products completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Cannot purchase less than one of something.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleItemsFailureItemOutOfStock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple items failure out of stock"];
    
    NSString *const apples = @"apples";
    NSString *const eggs = @"eggs";
    NSDictionary *products = @{eggs: @100, apples: @5};
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:products completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 404, @"Status code should be 404");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"The following items are not available: eggs");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (void)testPurchaseMultipleItemsFailureItemNotEnoughStock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test purchasing multiple items failure not enough stock"];
    
    NSString *const apples = @"apples";
    NSString *const eggs = @"eggs";
    NSDictionary *products = @{eggs: @101, apples: @30};
    
    [[GRSNetworkAPIUtility sharedUtility] purchaseProducts:products completion:^(NSDictionary *userInfo, NSError *error) {
        XCTAssertNil(userInfo, @"userInfo should be set to nil");
        
        NSHTTPURLResponse *response = [self httpResponseFromError:error];
        NSDictionary *errorJSON = [self jsonResponseFromError:error];
        
        XCTAssertEqual(response.statusCode, 400, @"Status code should be 400");
        XCTAssertEqualObjects([errorJSON objectForKey:ErrorJSONKey], @"Not enough stock to make purchase.");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TimeoutOneNetworkConnection handler:nil];
}

- (NSHTTPURLResponse *)httpResponseFromError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSHTTPURLResponse *response = [errorInfo objectForKey:AFNetworkingErrorURLResponseKey];
    
    return response;
}

- (NSDictionary *)jsonResponseFromError:(NSError *)error
{
    NSDictionary *errorInfo = error.userInfo;
    NSData *errorData = [errorInfo objectForKey:AFNetworkingErrorResponseDataKey];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
    return jsonDictionary;
}

@end
