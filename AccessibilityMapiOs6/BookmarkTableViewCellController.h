//
//  BookmarkTableViewCellController.h
//  MapGoogle
//
//  Created by apple on 9/23/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkTableViewCellController : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDetail;
@property (strong, nonatomic) IBOutlet UILabel *_phone;

//-(void) setAvailability:(int)idCode;

@end
