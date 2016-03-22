//
//  AccessTypeTableViewCell.h
//  MapGoogle
//
//  Created by Hackintosh on 10/19/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *_nameAccess;
@property (strong, nonatomic) IBOutlet UISwitch *typeSwitch;
@property int accessTypeID;
@end
