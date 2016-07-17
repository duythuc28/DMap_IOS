//
//  ViewController.h
//  AccessibilityMapiOs6
//
//  Created by apple on 10/2/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MainViewController.h"
#import "Location.h"
#import "PlaceInfoWindowView.h"
#import <CoreLocation/CoreLocation.h>
// Cluster Map View
#import "HSClusterMapView.h"
#import "HSDemoClusterRenderer.h"

@interface ViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate , PlaceInfoWindowDelegate>
@property (strong) MainViewController*  parentController;
//@property (strong )GMSMapView*          mapview;
@property (strong, nonatomic) HSClusterMapView *clusterMapView;
@property (strong) GMSPolyline*         polyline;
@property (strong, nonatomic) PlaceInfoWindowView * placeInfoView;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong) GMSCameraUpdate *    camerapos;
@property (strong, nonatomic) NSMutableArray* markers;
- (void) reloadMarker;
- (void) updateCamWithLocation:(Location*)search;
- (void) DrawMap:(NSString*)latlocation1 andlongLocation1:(NSString*)longlocation1 andlatLocation2:(NSString*)latlocation2 andlongLocation2:(NSString*)longlocation2 andisBus:(bool)isBus;
- (void) updateCam:(double)latitude1 andlongitude:(double)longitude1 andlatitude2:(double)latitude2 andlongitude2:(double)longitude2 ;
- (void)didSelectGetCurrentLocationButton;
@end
