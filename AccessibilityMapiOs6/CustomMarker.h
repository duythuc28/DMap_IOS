//
//  CustomMarker.h
//  MapGoogle
//
//  Created by apple on 9/16/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "Location.h"
@interface CustomMarker : GMSMarker

@property           Location    *location;
@property bool locationMarker; // 0 is not important, 1 is location marker
- (void)setType:(int) typeCode;

- (id)initWithVariables:(Location*)location;
- (id)initRaw:(CLLocationCoordinate2D)location;
@end
