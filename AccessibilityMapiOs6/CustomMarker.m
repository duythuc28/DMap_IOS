//
//  CustomMarker.m
//  MapGoogle
//
//  Created by apple on 9/16/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "CustomMarker.h"
#import "LocationType.h"
#import <GoogleMaps/GoogleMaps.h>
@implementation CustomMarker

- (void)setType:(int) typeCode{
    //Simulate id = 1 is schools
    UIImage * image = [LocationType getImageByLocationTypeId:[self.location.location_LocationType.locationTypeID intValue]];
    self.icon = image;
}


- (id)initWithVariables:(Location*)location{
    self = [super init];
    self.location = location;
    self.position = CLLocationCoordinate2DMake([self.location.latitude doubleValue], [self.location.longtitude doubleValue]);
    [self setType:[location.location_LocationType.locationTypeID intValue]];
    //id test = location.location_LocationType.isCheck;
    self.locationMarker = 1;
    return self;
}

- (id)initRaw:(CLLocationCoordinate2D)location{
    self = [super init];
    self.position = location;
    self.locationMarker = 0;
    return  self;
}



@end
