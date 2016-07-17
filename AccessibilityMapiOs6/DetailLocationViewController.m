//
//  DetailLocationViewController.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "DetailLocationViewController.h"
#import "LocationTabBarController.h"
#import "DetailLocationTableViewController.h"
#import "MDDirectionService.h"
#import "Location.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "Reachability.h"
#import "FromToRouteView.h"
#import "LocalizeHelper.h"
#import "Utils.h"
@interface DetailLocationViewController ()
@end

@implementation DetailLocationViewController

NSMutableArray *waypoints_;
NSMutableArray *waypointStrings_;
bool isBus ;
LocationTabBarController * tabBar ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utils checkInternetConnection];
    tabBar = (LocationTabBarController*)self.tabBarController;
    tabBar.navigationItem.title = LocalizedString(@"Details");
    [tabBar toggleBarButton:NO];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LocalizedString(@"Details");
    [self.bikeButton setTitle:LocalizedString(@"Bike") forState:UIControlStateNormal];
    [self.busButton setTitle:LocalizedString(@"Bus") forState:UIControlStateNormal];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];

    tabBar = (LocationTabBarController*)self.tabBarController;
    tabBar.navigationItem.title = LocalizedString(@"Details");
    self.labelTitle.text   = tabBar.locationInfo.title;
    self.labelAddress.text = tabBar.locationInfo.address;
    //[tabBar toggleBarButton:NO];
    
    if(tabBar.locationInfo.phone.length > 0)
        self.labelPhone.text   = tabBar.locationInfo.phone;

    self.marker = [[CustomMarker alloc]initWithVariables:tabBar.locationInfo];
    //[self.tabBarItem ]
//    UITabBar *tabBaritem = tabBar.tabBar;
//    UITabBarItem *tabBarItem1 = [tabBaritem.items objectAtIndex:0];
//    UITabBarItem *tabBarItem2 = [tabBaritem.items objectAtIndex:1];
//    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"locationdt.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"locationdt_selected.png"]];
//    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"feedback.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"feedback_selected.png"]];
//    tabBarItem2.title = LocalizedString(@"Feedback");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"tableViewAccessTypeSegue"]){
        DetailLocationTableViewController * tableView = (DetailLocationTableViewController*)segue.destinationViewController;
        tableView.tabBar = self.tabBarController;
    }
}

-(IBAction)findWay:(id)sender
{
    isBus = YES;
    [self drawDirection];
}

-(IBAction)findCarway:(id)sender
{
    isBus = NO;
    [self drawDirection];
}
-(void)drawDirection{
    if ([Utils checkInternetConnection] == YES)
    {
        LocationTabBarController * tabBar = (LocationTabBarController*)self.tabBarController;
        MainViewController *mainController = (MainViewController *)tabBar.rootViewController;
        ViewController *mapViewController = (ViewController *)mainController._mapViewController;
        
        if(mapViewController.clusterMapView.myLocation){
            self.routeview = [[FromToRouteView alloc]initWithNibName:@"FromToRouteView" bundle:nil withparentcontroller:self];
            self.routeview._myLocationtitle = LocalizedString(@"Current Location");
            self.routeview._destinationtitle = self.marker.location.title;
            [self.view addSubview:self.routeview.view];
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //GMSMapView* mapView =  mapViewController.mapview;
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(@"Error GPS")
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"Ok")
                                                        otherButtonTitles:nil];
                [message show];
            });
        }
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                          message:LocalizedString(@"Error Internet Connection")
                                                         delegate:nil
                                                cancelButtonTitle:LocalizedString(@"Ok")
                                                otherButtonTitles:nil];
        [message show];
        
    }
}

- (void)showWay:(ViewController*)mapViewController{
    NSObject * GPS = [[NSObject alloc]init];
    NSObject * marker= [[NSObject alloc]init];
    
    
    if (self.isGo == TRUE)
    {
        [waypoints_ addObject:GPS];
        NSString *positionString1 = [[NSString alloc] initWithFormat:@"%f,%f",
                                     mapViewController.clusterMapView.myLocation.coordinate.latitude,mapViewController.clusterMapView.myLocation.coordinate.longitude];
        [waypointStrings_ addObject:positionString1];
        
        [waypoints_ addObject:marker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    self.marker.position.latitude,self.marker.position.longitude];
        [waypointStrings_ addObject:positionString];
        
        [mapViewController updateCam:mapViewController.clusterMapView.myLocation.coordinate.latitude andlongitude:mapViewController.clusterMapView.myLocation.coordinate.longitude andlatitude2:self.marker.position.latitude andlongitude2:self.marker.position.longitude];
    }
    else
    {
        [waypoints_ addObject:marker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    self.marker.position.latitude,self.marker.position.longitude];
        [waypointStrings_ addObject:positionString];
        
        [waypoints_ addObject:GPS];
        NSString *positionString1 = [[NSString alloc] initWithFormat:@"%f,%f",
                                     mapViewController.clusterMapView.myLocation.coordinate.latitude,mapViewController.clusterMapView.myLocation.coordinate.longitude];
        [waypointStrings_ addObject:positionString1];
        
        [mapViewController updateCam:mapViewController.clusterMapView.myLocation.coordinate.latitude andlongitude:mapViewController.clusterMapView.myLocation.coordinate.longitude andlatitude2:self.marker.position.latitude andlongitude2:self.marker.position.longitude];
        //[mapViewController updateCam:self.marker.position.latitude andlongitude:self.marker.position.longitude];

        
    }
    
    
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

-(void)addBusDirections:(NSDictionary*)json
{
    LocationTabBarController * tabBar = (LocationTabBarController*)self.tabBarController;
    MainViewController *mainController = (MainViewController *)tabBar.rootViewController;
    ViewController *mapViewController = (ViewController *)mainController._mapViewController;
    if ([[json objectForKey:@"routes"] count]) {
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
                mapViewController.polyline = [GMSPolyline polylineWithPath:path];
                mapViewController.polyline.strokeWidth = 2;
                mapViewController.polyline.strokeColor =[UIColor greenColor];
                mapViewController.polyline.map = mapViewController.clusterMapView;
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
                marker.title =LocalizedString(@"Walking");
                marker.snippet = dis;
                marker.map= mapViewController.clusterMapView;
                marker.zIndex = 100;
                
            }
            else if ([travel isEqualToString:@"TRANSIT"])
            {
                mapViewController.polyline = [GMSPolyline polylineWithPath:path];
                mapViewController.polyline.strokeWidth = 2;
                mapViewController.polyline.strokeColor =[UIColor redColor];
                mapViewController.polyline.map = mapViewController.clusterMapView;
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
                marker.title = LocalizedString(@"Bus");
                marker.snippet = busname;
                marker.map= mapViewController.clusterMapView;
                marker.zIndex = 100;
            }
        }
    }
}
//
- (void)addDirections:(NSDictionary *)json {
    LocationTabBarController * tabBar = (LocationTabBarController*)self.tabBarController;
    MainViewController *mainController = (MainViewController *)tabBar.rootViewController;
    ViewController *mapViewController = (ViewController *)mainController._mapViewController;
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    NSDictionary *legs = [routes objectForKey:@"legs"][0];
    NSDictionary * distance = [legs objectForKey:@"distance"];
    NSString *dis= [distance objectForKey:@"text"];
    NSDictionary * steps = [legs objectForKey:@"steps"][0];
    NSDictionary * end = [steps objectForKey:@"start_location"];
    NSString * latitude = [end objectForKey:@"lat"];
    NSString * longitude= [end objectForKey:@"lng"];
    
    //Create marker
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    CustomMarker * marker = [[CustomMarker alloc] initRaw:position];
    
    marker.icon = [UIImage imageNamed:@"bike"];
    marker.title =LocalizedString(@"Bike");
    marker.snippet = dis;
    marker.map= mapViewController.clusterMapView;
    marker.zIndex = 100;
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    mapViewController.polyline = [GMSPolyline polylineWithPath:path];
    mapViewController.polyline.strokeWidth = 2;
    mapViewController.polyline.strokeColor =[UIColor redColor];
    mapViewController.polyline.map = mapViewController.clusterMapView;
    
    
}
-(IBAction)bookmarklocation:(id)sender;
{
    [Location bookmarkTheMarker:self.marker];
    CustomMarker *cusMark = (CustomMarker*)self.marker;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * bookmarkMessage = LocalizedString(@"Bookmark Success");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                          message:[NSString stringWithFormat:@"%@ %@",bookmarkMessage,cusMark.location.title]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    });
}


@end
