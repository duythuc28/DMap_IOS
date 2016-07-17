//
//  HSMapView.m
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import "HSMapView.h"
#import "HSDistanceUtil.h"

const CGFloat HS_MAP_VIEW_METERS_TO_MILES = 0.000621371;


@interface HSMapView ()

/**
 * The ordered set of markers currently on the map.
 */
@property (strong, nonatomic) NSMutableOrderedSet *markers;

/**
 * Used to sort the GMSMarkers by latitude.
 * Necessary to keep clusters from "jumping" around the map when
 * the map is reclustered and the set of markers does not change.
 */
@property (strong, nonatomic) NSComparator latitudeComparator;

@end


@implementation HSMapView


#pragma mark - initialization/setup

-(instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup {
    _markers = [NSMutableOrderedSet new];
    _latitudeComparator = ^NSComparisonResult(GMSMarker *firstMarker, GMSMarker *secondMarker) {
        if (firstMarker.position.latitude < secondMarker.position.latitude) {
            return NSOrderedAscending;
        }
        else if (firstMarker.position.latitude > secondMarker.position.latitude) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    };
}


#pragma mark - add/remove

-(void)addMarker:(GMSMarker *)marker {
    marker.map = self;
    // Keep the markers sorted by latitude (an arbitrary metric)
    NSUInteger index = [_markers indexOfObject:marker
                                 inSortedRange:(NSRange){0, _markers.count}
                                       options:NSBinarySearchingInsertionIndex
                               usingComparator:self.latitudeComparator];
    [_markers insertObject:marker atIndex:index];
}

-(void)addMarkers:(NSArray *)markers {
    for (GMSMarker *marker in markers) {
        [self addMarker:marker];
    }
}

-(void)removeMarker:(GMSMarker *)marker {
    marker.map = nil;
    [_markers removeObject:marker];
}

-(void)removeMarkers:(NSArray *)markers {
    for (GMSMarker *marker in markers) {
        [self removeMarker:marker];
    }
}

-(void)clear {
    [super clear];
    [_markers removeAllObjects];
}


#pragma mark - properties

-(NSArray *)displayedMarkers {
    // Return a read-only copy of the internal markers
    return [_markers copy];
}

-(MKCoordinateSpan)visibleSpan {
    // Convert the visible region to an MKCoordinateSpan
    return [HSDistanceUtil spanForCenter:self.camera.target
                           visibleRegion:self.projection.visibleRegion];
}

-(CGFloat)visibleRadiusInMiles {
    CLLocationCoordinate2D topRightCoordinate = self.projection.visibleRegion.farRight;
    CLLocationCoordinate2D bottomRightCoordinate = self.projection.visibleRegion.nearRight;
    CLLocation *topRight = [[CLLocation alloc] initWithLatitude:topRightCoordinate.latitude
                                                      longitude:topRightCoordinate.longitude];
    CLLocation *bottomRight = [[CLLocation alloc] initWithLatitude:bottomRightCoordinate.latitude
                                                         longitude:bottomRightCoordinate.longitude];
    return ([topRight distanceFromLocation:bottomRight] * HS_MAP_VIEW_METERS_TO_MILES) / 2.0;
}

@end
