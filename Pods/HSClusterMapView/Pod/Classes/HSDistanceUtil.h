//
//  HSDistanceUtil.h
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface HSDistanceUtil : NSObject

/**
 * Calculates the distance between two CLLocationCoordinate2D instances
 * @param c1
 * @param c2
 * @return the distance between c1 and c2
 */
double CLLocationCoordinateDistance(CLLocationCoordinate2D c1,
                                    CLLocationCoordinate2D c2);

/**
 * Converts a GMSVisibleRegion to an MKCoordinateSpan using a center coordinate
 * @param center - the GMSMapView's camera target
 * @param visibleRegion - the GMSMapView's projection's visible region
 * @return an MKCoordinateSpan representation of the GMSVisibleRegion
 */
+(MKCoordinateSpan)spanForCenter:(CLLocationCoordinate2D)center
                   visibleRegion:(GMSVisibleRegion)visibleRegion;

@end
