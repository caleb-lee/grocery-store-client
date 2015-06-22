//
//  Product.h
//  
//
//  Created by Caleb Lee on 2015/06/22.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;

@end
