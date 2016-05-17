//
//  DetailViewController.h
//  DMap
//
//  Created by IOSDev on 5/13/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfoViewController.h"
#import "Location.h"

@interface DetailViewController : UITableViewController <DetailInfoViewDelegate>
@property (strong, nonatomic) Location * locationInfo;
@end
