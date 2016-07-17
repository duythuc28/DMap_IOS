//
//  HSClusterRenderer.h
//  HotSchedules
//
//  Created by Alan Bouzek on 3/31/15.
//  Copyright (c) 2015 HotSchedules. All rights reserved.
//

#ifndef HotSchedules_HSClusterRenderer_h
#define HotSchedules_HSClusterRenderer_h

/**
 * Used to render a custom UIImage for each HSClusterMarker.
 * An NSObject implementing this protocol should be passed as an argument to
 * an initalizer of HSClusterMapView.
 */
@protocol HSClusterRenderer <NSObject>

/**
 * Generates an image for a HSClusterMarker
 * @param count - the count of markers within the cluster
 * @return an image to use for this HSClusterMarker
 */
-(UIImage *)imageForClusterWithCount:(NSUInteger)count;

@end

#endif
