//
//  CustomTextField.m
//  CustomTextField
//
//  Created by IOSDev on 3/16/16.
//  Copyright © 2016 ALP. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *) borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.padding, 0);
}

- (CGRect) editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)textFieldShake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES;
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
