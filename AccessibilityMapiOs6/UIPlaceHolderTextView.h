//
//  UIPlaceHolderTextView.h
//  DMap
//
//  Created by MC976 on 8/1/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end