//
//  HSMapView.h
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface HSMapView : GMSMapView

/**
 * A read-only array of the markers currently placed on the map (both on and off screen).
 * NOTE: If using the HSClusterMapView subclass, GMSMarkers within a HSClusterMarker will 
 * not be present within this array. See the unclusteredMarkers property of HSClusterMapView.
 */
@property (nonatomic, readonly) NSArray *displayedMarkers;

/**
 * The MKCoordinateSpan representation of the currently visible region.
 */
@property (nonatomic, readonly) MKCoordinateSpan visibleSpan;

/**
 * The radius of the visible region in represented in miles.
 */
@property (nonatomic, readonly) CGFloat visibleRadiusInMiles;


/**
 * Adds a single marker to the map
 * @param marker - the marker to add to the map
 */
-(void)addMarker:(GMSMarker *)marker;

/**
 * Adds an array of GMSMarkers to the map
 * @param markers - an array of GMSMarkers to add to the map
 */
-(void)addMarkers:(NSArray *)markers;

/**
 * Removes a single marker from the map
 * @param marker - the marker to remove from the mapp
 */
-(void)removeMarker:(GMSMarker *)marker;

/**
 * Removes an array of GMSMarkers from the map
 * @param markers - an array of GMSMarkers to remove from the map
 */
-(void)removeMarkers:(NSArray *)markers;

/**
 * Removes all currently displayed GMSMarkers from the map
 */
-(void)clear;

@end
