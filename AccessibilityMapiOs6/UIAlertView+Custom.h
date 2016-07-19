//
//  UIAlertView+Custom.h
//  DMap
//
//  Created by MC976 on 7/19/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Custom)
+ (void)createAlertViewWithTitle:(NSString *)sTitle
                         message:(NSString *)sMessage
              sCancelButtonTitle:(NSString *)sTitleCancelButton  sOtherButtonTitle:(NSString *)sTitleOtherButton
                              on:(UIViewController *)delegate;
@end
