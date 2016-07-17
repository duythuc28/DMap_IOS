//
//  HSClusterMarker.m
//  HotSchedules
//
//  Created by Alan Bouzek on 3/30/15.
//  Adapted from OCAnnotation.m - Created by Botond Kis on 14.07.11
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#import "HSClusterMarker.h"
#import <QuartzCore/QuartzCore.h>

@interface HSClusterMarker ()

/**
 * A mutable, ordered set representation of the markers held within this cluster
 */
@property (nonatomic, strong) NSMutableOrderedSet *markersInCluster;

@end


@implementation HSClusterMarker


#pragma mark - initialization/setup

-(instancetype)init {
    if (self = [super init]) {
        _markersInCluster = [NSMutableOrderedSet new];
    }
    return self;
}

-(instancetype)initWithMarker:(GMSMarker *)marker {
    if (self = [self init]) {
        self.position = marker.position;
        self.appearAnimation = kGMSMarkerAnimationPop;
        [_markersInCluster addObject:marker];
    }
    return self;
}


#pragma mark - add/remove

-(void)addMarker:(GMSMarker *)marker {
    [_markersInCluster addObject:marker];
}

-(void)addMarkers:(NSArray *)markers {
    [_markersInCluster addObjectsFromArray:markers];
}

-(void)removeMarker:(GMSMarker *)marker {
    [_markersInCluster removeObject:marker];
}

-(void)removeMarkers:(NSArray *)markers {
    for (GMSMarker *marker in markers) {
        [self removeMarker:marker];
    }
}


#pragma mark - properties

-(NSOrderedSet *)markersInCluster {
    return [_markersInCluster copy];
}

-(CLLocationCoordinate2D)center {
    if (_markersInCluster.count == 0) return CLLocationCoordinate2DMake(0, 0);
    
    // Find max/min coordinates
    HSClusterMarker *startMarker = [_markersInCluster firstObject];
    CLLocationCoordinate2D min = startMarker.position;
    CLLocationCoordinate2D max = startMarker.position;
    
    for (GMSMarker *marker in _markersInCluster) {
        min.latitude = MIN(min.latitude, marker.position.latitude);
        min.longitude = MIN(min.longitude, marker.position.longitude);
        max.latitude = MAX(max.latitude, marker.position.latitude);
        max.longitude = MAX(max.longitude, marker.position.longitude);
    }
    
    // Calculate the center
    CLLocationCoordinate2D center = min;
    center.latitude += (max.latitude - min.latitude) / 2.0;
    center.longitude += (max.longitude - min.longitude) / 2.0;
    
    return center;
}


#pragma mark - equality

- (BOOL)isEqual:(HSClusterMarker *)marker {
    if (![marker isKindOfClass:[HSClusterMarker class]]) {
        return NO;
    }
    
    return (fabs(self.center.latitude -  marker.center.latitude) <= 0.000001 &&
            fabs(self.center.longitude - marker.center.longitude) <= 0.000001 &&
            self.markersInCluster.count == marker.markersInCluster.count);
}


@end
