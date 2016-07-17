//
//  DetailInfoViewController.m
//  DMap
//
//  Created by IOSDev on 5/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UIButton *placePhone;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation DetailInfoViewController

- (id)initWithFrame:(CGRect)frame selectedLocation:(Location *)location {
    self = [super initWithNibName:@"DetailViewInfo" bundle:nil];
    if (self) {
        self.view.frame = frame;
//        [self setupMapView:location];
        self.currentLocation = location;
        [self displayDetailInfo:location.title
                        address:location.address
                    phoneNumber:location.phone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupMapView:self.currentLocation];
}

- (void)setupMapView:(Location *)location {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[location.latitude floatValue]
                                                            longitude:[location.longtitude floatValue]
                                                                 zoom:16];
    [self.mapView setCamera:camera];
    self.mapView.padding = UIEdgeInsetsMake(80, 0, 0, 0);
//    self.mapView.settings.scrollGestures = NO;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longtitude floatValue]);
    marker.title = location.title;
    marker.snippet = location.address;
    marker.icon = [LocationType getImageByLocationTypeId:[location.location_LocationType.locationTypeID intValue]];
    marker.map = self.mapView;
    self.mapView.selectedMarker = marker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayDetailInfo:(NSString *)title
                   address:(NSString *)address
              phoneNumber : (NSString *)phoneNumber {
    self.placeTitle.text = title;
    self.placeAddress.text = address;
    if ([phoneNumber isEqualToString:@""] || !phoneNumber) {
        self.placePhone.hidden = YES;
    } else {
        self.placePhone.hidden = NO;
        [self.placePhone setTitle:phoneNumber forState:UIControlStateNormal];
    }
   
}

- (IBAction)callButtonClicked:(id)sender {
    [self.delegate callButtonClicked];
}


@end
