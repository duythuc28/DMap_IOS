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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:@"DetailViewInfo" bundle:nil];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMapView:self.currentLocation];
}

- (void)setupMapView:(Location *)location {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[location.latitude floatValue]
                                                            longitude:[location.longtitude floatValue]
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([location.latitude floatValue], [location.longtitude floatValue]);
    marker.title = location.title;
    marker.snippet = location.address;
    marker.icon = [LocationType getImageByLocationTypeId:[location.locationID intValue]];
    marker.map = self.mapView;
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
    [self.placePhone setTitle:phoneNumber forState:UIControlStateNormal];
}

- (IBAction)callButtonClicked:(id)sender {
    [self.delegate callButtonClicked];
}


@end
