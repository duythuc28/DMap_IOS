//
//  CustomTextField.h
//  CustomTextField
//
//  Created by IOSDev on 3/16/16.
//  Copyright © 2016 ALP. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomTextField : UITextField
@property (nonatomic) IBInspectable CGFloat padding;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor * borderColor;
- (void)textFieldShake;
@end
