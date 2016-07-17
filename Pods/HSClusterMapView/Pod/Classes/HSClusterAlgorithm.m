//
//  HSClusterAlgorithm.m
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import "HSClusterAlgorithm.h"
#import <GoogleMaps/GoogleMaps.h>
#import "HSClusterMarker.h"
#import "HSDistanceUtil.h"

@implementation HSClusterAlgorithm

+(NSArray *)bubbleClustersFromMarkers:(NSArray *)markersToCluster
                        clusterRadius:(CLLocationDistance)radius {
    NSMutableArray *clusteredMarkers = [NSMutableArray new];
    
    for (GMSMarker *marker in markersToCluster) {
        // Try to find existing cluster to fit in
        BOOL foundCluster = NO;
        for (HSClusterMarker *clusterMarker in clusteredMarkers) {
            // If this marker is in the radius of the cluster marker, add it
            if ((CLLocationCoordinateDistance(marker.position, clusterMarker.position) <= radius)) {
                foundCluster = YES;
                [clusterMarker addMarker:marker];
                break;
            }
        }
        
        // If the marker wasn't added to a cluster, create a new one
        if (!foundCluster){
            HSClusterMarker *newClusterMarker = [[HSClusterMarker alloc] initWithMarker:marker];
            [clusteredMarkers addObject:newClusterMarker];
        }
    }
    
    // Remove all empty or single cluster markers
    NSMutableArray *returnArray = [NSMutableArray new];
    for (HSClusterMarker *clusterMarker in clusteredMarkers) {
        if (clusterMarker.markersInCluster.count == 1) {
            [returnArray addObject:[clusterMarker.markersInCluster firstObject]];
        }
        else if (clusterMarker.markersInCluster.count > 1) {
            [returnArray addObject:clusterMarker];
        }
    }
    
    return returnArray;

}

@end
