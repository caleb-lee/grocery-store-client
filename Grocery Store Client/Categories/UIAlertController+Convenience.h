//
//  UIAlertController+Convenience.h
//  Grocery Store Client
//
//  Created by Caleb Lee on 2015/06/23.
//  Copyright (c) 2015年 Vokal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Convenience)

/**
 *  Prepares and shows a UIAlertController in the alert style
 *  with the given title and message in the given View Controller.
 *
 *  @param title          title of the alert to show
 *  @param message        message of the alert to show
 *  @param viewController viewController to present in
 */
+ (void)presentAlertWithTitle:(NSString *)title
                   andMessage:(NSString *)message
             inViewController:(UIViewController *)viewController;

@end
