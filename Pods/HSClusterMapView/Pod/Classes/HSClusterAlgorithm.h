//
//  HSClusterAlgorithm.h
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HSClusterAlgorithm : NSObject

/**
 * Forms HSClusterMarkers from GMSMarkers.
 * @param markersToCluster - an array of GMSMarkers to form clusters from
 * @param radius - the size of the radius to form clusters using
 * @return an array of GMSMarker and HSClusterMarker instances
 */
+(NSArray *)bubbleClustersFromMarkers:(NSArray *)markersToCluster
                        clusterRadius:(CLLocationDistance)radius;

@end
