//
//  PlaceInfoWindowView.m
//  DMap
//
//  Created by MC976 on 3/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "PlaceInfoWindowView.h"

@implementation PlaceInfoWindowView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PlaceInfoWindowView" owner:self options:nil] firstObject];
        self.frame = frame;
        self.subView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.subView.layer.borderWidth = 0.5;
        self.placeIcon.layer.borderWidth = 0.5;
        self.placeIcon.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.alpha = 0.0;
    }
    return self;
}

- (IBAction)placeInfoViewClicked:(id)sender {
    [self.delegate placeInfoViewClicked:self];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.delegate closeButtonClicked:self];
}


@end
