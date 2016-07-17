//
//  HSDistanceUtil.m
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import "HSDistanceUtil.h"

@implementation HSDistanceUtil

double CLLocationCoordinateDistance(CLLocationCoordinate2D c1,
                                    CLLocationCoordinate2D c2) {
    return sqrt(pow(c1.latitude  - c2.latitude , 2.0) +
                pow(c1.longitude - c2.longitude, 2.0));
}

+(MKCoordinateSpan)spanForCenter:(CLLocationCoordinate2D)center
                   visibleRegion:(GMSVisibleRegion)visibleRegion {
    CLLocationDegrees latitudeDelta = visibleRegion.farLeft.latitude - visibleRegion.nearLeft.latitude;
    CLLocationDegrees longitudeDelta = visibleRegion.farRight.longitude - visibleRegion.farLeft.longitude;
    return MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
}

@end
