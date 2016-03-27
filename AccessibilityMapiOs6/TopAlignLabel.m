//
//  TopAlignLabel.m
//  DMap
//
//  Created by MC976 on 3/28/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "TopAlignLabel.h"

@implementation TopAlignLabel
- (void)drawTextInRect:(CGRect)rect {
    if (self.text) {
        CGSize labelStringSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:self.font}
                                                         context:nil].size;
        [super drawTextInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame),labelStringSize.height)];
    } else {
        [super drawTextInRect:rect];
    }
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}
@end
