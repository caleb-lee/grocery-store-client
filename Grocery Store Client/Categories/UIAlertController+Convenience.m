//
//  UIAlertController+Convenience.m
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/23.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import "UIAlertController+Convenience.h"

@implementation UIAlertController (Convenience)

+ (void)presentAlertWithTitle:(NSString *)title
                   andMessage:(NSString *)message
             inViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
