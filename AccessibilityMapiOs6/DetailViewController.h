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
#import "CommentPopupView.h"

@interface DetailViewController : UITableViewController <DetailInfoViewDelegate, CommentPopupViewDelegate>
@property (strong, nonatomic) Location * locationInfo;
@end
