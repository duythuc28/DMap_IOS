//
//  TableViewCell.h
//  MapGoogle
//
//  Created by Hackintosh on 10/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *_title;
@property (strong, nonatomic) IBOutlet UILabel *address;

@end
