//
//  PlaceInfoCell.m
//  DMap
//
//  Created by IOSDev on 3/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "PlaceInfoCell.h"
#import "LocationType.h"

@implementation PlaceInfoCell

- (void)setUpCellWithPlace:(Location *) location {
    self.placeTitle.text  =  location.title;
    self.placeDescription.text = location.address;
    self.placeImage.image = [LocationType getImageByLocationTypeId:[location.location_LocationType.locationTypeID intValue]];
}

@end
