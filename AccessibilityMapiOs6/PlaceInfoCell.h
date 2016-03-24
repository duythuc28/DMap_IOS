//
//  PlaceInfoCell.h
//  DMap
//
//  Created by IOSDev on 3/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface PlaceInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * placeImage;
@property (weak, nonatomic) IBOutlet UILabel     * placeTitle;
@property (weak, nonatomic) IBOutlet UILabel     * placeDescription;
- (void)setUpCellWithPlace:(Location *)location;
@end
