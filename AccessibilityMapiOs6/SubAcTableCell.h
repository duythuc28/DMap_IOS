//
//  SubAcTableCell.h
//  MapGoogle
//
//  Created by Hackintosh on 11/5/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubAcTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *accessname;
@property (strong, nonatomic) IBOutlet UISwitch *typeswitch;
@property int accessTypeID;
@property (nonatomic) NSInteger accessRow;
@end
