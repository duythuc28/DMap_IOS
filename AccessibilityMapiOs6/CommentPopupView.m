//
//  CommentPopupView.m
//  DMap
//
//  Created by iOSDev on 7/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "CommentPopupView.h"

@implementation CommentPopupView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentPopupView" owner:self options:nil] firstObject];
    }
    return self;
}
@end
