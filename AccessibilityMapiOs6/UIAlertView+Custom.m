//
//  UIAlertView+Custom.m
//  DMap
//
//  Created by MC976 on 7/19/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "UIAlertView+Custom.h"

@implementation UIAlertView (Custom)
+ (void)createAlertViewWithTitle:(NSString *)sTitle
                         message:(NSString *)sMessage
              sCancelButtonTitle:(NSString *)sTitleCancelButton  sOtherButtonTitle:(NSString *)sTitleOtherButton
                              on:(UIViewController *)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sTitle
                                                    message:sMessage
                                                   delegate:delegate
                                          cancelButtonTitle:sTitleCancelButton
                                          otherButtonTitles:sTitleOtherButton,nil];
    [alert show];
}

@end
