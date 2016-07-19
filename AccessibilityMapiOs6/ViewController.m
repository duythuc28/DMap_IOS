//
//  ViewController.m
//  AccessibilityMapiOs6
//
//  Created by apple on 10/2/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "ViewController.h"
#import "CustomMarker.h"
#import "MDDirectionService.h"
#import "Location.h"
#import "AppDelegate.h"
#import "CustomInfoWindowView.h"
#import "RouteViewController.h"
#import "DownloadData.h"
#import <MapKit/MapKit.h>
#import "LocationTabBarController.h"
#import "LocalizeHelper.h"

@interface ViewController ()

@end

@implementation ViewController
{
    BOOL firstLocationUpdate_;
    NSMutableArray* waypoints_;
    NSMutableArray* waypointStrings_;
    UIControl * mapViewControl;
}

- (PlaceInfoWindowView *)placeInfoView {
    if (!_placeInfoView) {
        
        mapViewControl = [[UIControl alloc]initWithFrame:self.view.frame];

        [mapViewControl addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:mapViewControl];
        
        _placeInfoView = [[PlaceInfoWindowView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150)];
        _placeInfoView.delegate = self;
        [self.view addSubview:_placeInfoView];
    }
    return _placeInfoView;
}
- (NSMutableArray *)markers {
    if (!_markers) {
        _markers = [[NSMutableArray alloc]init];
    }
    return _markers;
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied ) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self requestAlwaysAuthorization];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.770116
                                                            longitude:106.692401
                                                                 zoom:11];
    
    HSDemoClusterRenderer *clusterRenderer = [HSDemoClusterRenderer new];
    self.clusterMapView = [[HSClusterMapView alloc] initWithFrame:self.view.bounds renderer:clusterRenderer];
    self.clusterMapView.delegate = self;
    [self.clusterMapView setCamera:camera];
    [self.view addSubview:self.clusterMapView];
    [self.view sendSubviewToBack:self.clusterMapView];
    
//    self.mapview = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    self.mapview.settings.myLocationButton      = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.clusterMapView.myLocationEnabled = YES;
    });
    [self reloadMarker];
    [self.clusterMapView cluster];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self reloadMarker];
    [self.clusterMapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"myLocation"];
//    [self closeInfoWindow];
    [self.clusterMapView removeObserver:self forKeyPath:@"myLocation"];
    
}
- (void)reloadMarker{
    [self.clusterMapView clear];
    [self createMarkerObjects];
    
    //Draw circle
//    NSArray* settings = [[NSUserDefaults standardUserDefaults]objectForKey:@"settings"];
//    int radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"]intValue];
//    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(self.mapview.camera.target.latitude, self.mapview.camera.target.longitude);
//    GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
//                                             radius:radius *1000];
//    
//    circ.fillColor = [UIColor colorWithRed:0.4 green:0.7 blue:1 alpha:0.05];
//    circ.strokeColor = [UIColor colorWithRed:0.4 green:0.7 blue:1 alpha:1];
//    circ.strokeWidth = 2;
//    circ.map = self.mapview;
}


- (void)createMarkerObjects{
//    NSArray* settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
//    int radius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"radius"]intValue];
//    CLLocation* zoomLocation = [[CLLocation alloc]initWithLatitude:self.mapview.camera.target.latitude longitude:self.mapview.camera.target.longitude];
//    NSArray* bookmarks = [Location getDataWithCurrentZoomPos:zoomLocation withDistanceInKilomiter:radius];
    NSArray * locations = [Location getAllData];
    for(Location *data in locations)
    {
        CustomMarker *marker = [[CustomMarker alloc] initWithVariables:data];
        marker.map = self.clusterMapView;
        [self.markers addObject:marker];
        [self.clusterMapView addMarker:marker];
    }
}

- (void) updateCam:(double)latitude1 andlongitude:(double)longitude1 andlatitude2:(double)latitude2 andlongitude2:(double)longitude2
{
    CLLocationCoordinate2D location1 =
    CLLocationCoordinate2DMake(latitude1, longitude1);
    CLLocationCoordinate2D location2 =
    CLLocationCoordinate2DMake(latitude2, longitude2);
    
    
    float mapViewWidth = self.clusterMapView.frame.size.width;
    float mapViewHeight = self.clusterMapView.frame.size.height;
    
    // Camera Update
    
    MKMapPoint point1 = MKMapPointForCoordinate(location1);
    MKMapPoint point2 = MKMapPointForCoordinate(location2);
    
    MKMapPoint centrePoint = MKMapPointMake(
                                            (point1.x + point2.x) / 2,
                                            (point1.y + point2.y) / 2);
    CLLocationCoordinate2D centreLocation = MKCoordinateForMapPoint(centrePoint);
    
    double mapScaleWidth = mapViewWidth / fabs(point2.x - point1.x);
    double mapScaleHeight = mapViewHeight / fabs(point2.y - point1.y);
    double mapScale = MIN(mapScaleWidth, mapScaleHeight);
    
    double zoomLevel = 20 + log2(mapScale);
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude: centreLocation.latitude
                                 longitude: centreLocation.longitude
                                 zoom: zoomLevel-1];
    
    //GMSCameraPosition *bookmarkCamera = [GMSCameraPosition cameraWithLatitude:latitude1 longitude:longitude1 zoom:8];
    [self.clusterMapView setCamera:camera];
}

- (void)updateCamWithLocation:(Location *)search
{
    GMSCameraPosition *bookmarkCamera = [GMSCameraPosition cameraWithLatitude:[search.latitude doubleValue] longitude:[search.longtitude doubleValue] zoom:16];
    [self.clusterMapView setCamera:bookmarkCamera];
    
    __block CustomMarker* theMarker;
    [self.markers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CustomMarker* marker = obj;
        if(marker.location.latitude == search.latitude && marker.location.longtitude == search.longtitude){
            theMarker = marker;
            *stop = YES;
        }
    }];
    
    if(theMarker == nil){
        CustomMarker *marker = [[CustomMarker alloc] initWithVariables: search];
        marker.map = self.clusterMapView;
        [self.markers addObject:marker];
        theMarker = marker;
    }
    // Show info window at selected maker
//    [self setDefaultImageForMarker];
    [self showInfoWindowAtMarker:theMarker];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    if ([marker isKindOfClass:[CustomMarker class]]) {
        CustomMarker * cusMarker = (CustomMarker*)marker;
        if(cusMarker.locationMarker)
        {
            [self showInfoWindowAtMarker:marker];
            return YES;
        }
    }
    return NO;
}


/**
 *  Show info window at selected marker
 *
 *  @param marker selected marker
 */
- (void)showInfoWindowAtMarker:(GMSMarker *)marker {
    if (marker) {
        CustomMarker * cusMarker = (CustomMarker*)marker;
        [self.placeInfoView displayView:cusMarker];
        if (SCREEN_HEIGHT == self.placeInfoView.frame.origin.y) {
            [self.placeInfoView movePoint:CGPointMake(0, -214) duration:0.5 finished:nil];
        }
        self.parentController.roundButton.hidden = YES;
        mapViewControl.hidden = NO;
        GMSCameraUpdate * cameraUpdate = [GMSCameraUpdate setTarget:marker.position zoom:16];
        
        for (CustomMarker * customMarker in self.markers) {
            if (![customMarker isEqual:marker]) {
                customMarker.map = nil;
            } else {
                [self.clusterMapView animateWithCameraUpdate:cameraUpdate];
            }
        }
//        [self.clusterMapView animateWithCameraUpdate:cameraUpdate];
//        marker.icon = [UIImage imageNamed:@"selectedMarker"];
    }
}
/**
 *  Close Info Window
 */
- (void)closeInfoWindow {
    if (SCREEN_HEIGHT-214 == self.placeInfoView.frame.origin.y) {
        mapViewControl.hidden = YES;
        //???: Hard code
        [self.placeInfoView movePoint:CGPointMake(0, 214) duration:0.5 finished:nil];
        self.parentController.roundButton.hidden = NO;
        //    [self setDefaultImageForMarker];
        for (CustomMarker * customMarker in self.markers) {
            if (![customMarker isEqual:self.placeInfoView.customMarker]) {
                customMarker.map = self.clusterMapView;
            }
        }
    }
}

/**
 *  Set marker image back to unselected marker
 */
- (void)setDefaultImageForMarker {
    for (CustomMarker * customMarker in self.markers) {
        if ([customMarker isEqual:self.placeInfoView.customMarker]) {
            customMarker.icon = [LocationType getImageByLocationTypeId:[customMarker.location.location_LocationType.locationTypeID intValue]];
        }
    }
}

#pragma mark - Place Info View Delegate
- (void)closeButtonClicked:(PlaceInfoWindowView *)placeInfoView {
    [self closeInfoWindow];
}

- (void)placeInfoViewClicked:(PlaceInfoWindowView *)placeInfoView {
//    LocationTabBarController *detailView        = (LocationTabBarController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailTabBar"];
//        detailView.rootViewController = self.parentController;
//        detailView.locationInfo       = placeInfoView.customMarker.location;
//        [self.parentController.navigationController pushViewController:detailView animated:YES];
    [self.parentController performSegueWithIdentifier:@"kPushToDetailViewController" sender:self.parentController];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self.clusterMapView cluster];
}

//Tap on the marker
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:marker
{
    //CustomMarker *cusMarker = (CustomMarker*)marker;
//    CustomMarker * cusMarker = (CustomMarker*)marker;
//    if(cusMarker.locationMarker == TRUE)
//    {
//        LocationTabBarController *detailView        = (LocationTabBarController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailTabBar"];
//        
//        detailView.rootViewController = self.parentController;
//        detailView.locationInfo       = cusMarker.location;
//        
//        [self.parentController.navigationController pushViewController:detailView animated:YES];
//    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        //[self.locationManager startUpdatingLocation];
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        self.clusterMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                             zoom:13];
    }
}

-(void)DrawMap:(NSString *)latlocation1 andlongLocation1:(NSString *)longlocation1 andlatLocation2:(NSString *)latlocation2 andlongLocation2:(NSString *)longlocation2 andisBus:(bool)isBus
{
    NSObject * location1 = [[NSObject alloc]init];
    NSObject * location2= [[NSObject alloc]init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    [waypoints_ addObject:location1];
    NSString *positionString1 = [[NSString alloc] initWithFormat:@"%f,%f",
                                 [latlocation1 doubleValue],[longlocation1 doubleValue]];
    [waypointStrings_ addObject:positionString1];
    
    [waypoints_ addObject:location2];
    
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                [latlocation2 doubleValue],[longlocation2 doubleValue]];
    [waypointStrings_ addObject:positionString];
    
    [self updateCam:[latlocation1 doubleValue] andlongitude:[longlocation1 doubleValue] andlatitude2:[latlocation2 doubleValue] andlongitude2:[longlocation2 doubleValue]];
    
    //check condition
    
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        if(isBus == TRUE)
        {
            SEL selector =@selector(addBusDirections:);
            dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                [mds setDirectionsQueryByBus:query withSelector:selector withDelegate:self];
            });
            
        }
        else
        {
            SEL selector = @selector(addDirections:);
            dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                [mds setDirectionsQuery:query
                           withSelector:selector
                           withDelegate:self];
            });
        }
        
        
    }
}

- (void)addDirections:(NSDictionary *)json {
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    NSDictionary *legs = [routes objectForKey:@"legs"][0];
    NSDictionary * distance = [legs objectForKey:@"distance"];
    NSString *dis= [distance objectForKey:@"text"];
    NSDictionary * steps = [legs objectForKey:@"steps"][0];
    NSDictionary * end = [steps objectForKey:@"start_location"];
    NSString * latitude = [end objectForKey:@"lat"];
    NSString * longitude= [end objectForKey:@"lng"];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    CustomMarker * marker = [[CustomMarker alloc] initRaw:position];
    
    marker.icon = [UIImage imageNamed:@"bike"];
    marker.title = LocalizedString(@"Bike");
    marker.snippet = dis;
    marker.map= self.clusterMapView;
    marker.zIndex = 100;
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    self.polyline = [GMSPolyline polylineWithPath:path];
    self.polyline.strokeWidth = 2;
    self.polyline.strokeColor = [UIColor redColor];
    self.polyline.map = self.clusterMapView;
}

-(void)addBusDirections:(NSDictionary*)json
{
    NSDictionary * routes = [json objectForKey:@"routes"][0];
    NSDictionary * legs = [routes objectForKey:@"legs"][0];
    NSDictionary * steps = [legs objectForKey:@"steps"];
    for  (int i=0;i<steps.count;i++)
    {
        NSDictionary * step = [legs objectForKey:@"steps"][i];
        NSString * travel = [step objectForKey:@"travel_mode"];
        NSDictionary * route = [step objectForKey:@"polyline"];
        NSString * overview_route = [route objectForKey:@"points"];
        GMSPath * path= [GMSPath pathFromEncodedPath:overview_route];
        
        if ([travel isEqualToString:@"WALKING"])
        {
            self.polyline = [GMSPolyline polylineWithPath:path];
            self.polyline.strokeWidth = 2;
            self.polyline.strokeColor =[UIColor greenColor];
            self.polyline.map = self.clusterMapView;
            //NSDictionary * start = [step objectForKey:@"start_location"];
            NSDictionary * steps = [step objectForKey:@"steps"][0];
            NSDictionary * end = [steps objectForKey:@"start_location"];
            NSString * latitude = [end objectForKey:@"lat"];
            NSString * longitude= [end objectForKey:@"lng"];
            
            NSDictionary * distance = [step objectForKey:@"distance"];
            NSString * dis = [distance objectForKey:@"text"];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
            CustomMarker * marker = [[CustomMarker alloc] initRaw:position];
            
            marker.icon = [UIImage imageNamed:@"walking"];
            marker.title = LocalizedString(@"Walking");
            marker.snippet = dis;
            marker.map= self.clusterMapView;
            marker.zIndex = 100;
            
        }
        else if ([travel isEqualToString:@"TRANSIT"])
        {
            self.polyline = [GMSPolyline polylineWithPath:path];
            self.polyline.strokeWidth = 2;
            self.polyline.strokeColor =[UIColor redColor];
            self.polyline.map = self.clusterMapView;
            NSDictionary * transit= [step objectForKey:@"transit_details"];
            NSDictionary * stop= [transit objectForKey:@"departure_stop"];
            NSDictionary * location = [stop objectForKey:@"location"];
            NSString * latitude = [location objectForKey:@"lat"];
            NSString * longitude = [location objectForKey:@"lng"];
            NSDictionary * line = [transit objectForKey:@"line"];
            NSString * busname = [line objectForKey:@"name"];
            
            //Create marker
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
            CustomMarker * marker = [[CustomMarker alloc] initRaw:position];
            
            marker.icon = [UIImage imageNamed:@"bus"];
            marker.title =LocalizedString(@"Bus number");
            marker.snippet = busname;
            marker.map= self.clusterMapView;
            marker.zIndex = 100;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: Did fail request current Location
    NSLog(@"didFailWithError: %@", error);
}


- (void)didSelectGetCurrentLocationButton {
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentLocation = [locations lastObject];
    GMSCameraUpdate * cameraUpdate = [GMSCameraUpdate setTarget:currentLocation.coordinate zoom:13];
    [self.clusterMapView animateWithCameraUpdate:cameraUpdate];
    [self.locationManager stopUpdatingLocation];
}

@end
