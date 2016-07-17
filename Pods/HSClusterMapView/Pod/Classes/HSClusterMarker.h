//
//  HSClusterMarker.h
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Adapted from OCAnnotation.h - Created by Botond Kis on 14.07.11.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface HSClusterMarker : GMSMarker

/**
 * @return markers held within this cluster
 */
-(NSOrderedSet *)markersInCluster;


/**
 * Initializes the HSClusterMarker with a GMSMarker
 * @param marker - the GMSMarker to spawn the cluster
 * @return an instance of HSClusterMarker
 */
-(instancetype)initWithMarker:(GMSMarker *)marker;

/**
 * Adds a single marker to the cluster
 * @param marker - the marker to add
 */
-(void)addMarker:(GMSMarker *)marker;

/**
 * Adds multiple markers to the cluster
 * @param markers - the GMSMarkers to add
 */
-(void)addMarkers:(NSArray *)markers;

/**
 * Removes a single marker from the cluster
 * @param marker - the marker to remove
 */
-(void)removeMarker:(GMSMarker *)marker;

/**
 * Removes multiple markers from the cluster
 * @param markers - the GMSMarkers to remove
 */
-(void)removeMarkers:(NSArray *)markers;

@end
