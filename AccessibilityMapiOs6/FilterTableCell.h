//
//  FilterTableCell.h
//  MapGoogle
//
//  Created by apple on 10/14/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeTitle;
@property (strong, nonatomic) IBOutlet UISwitch *typeSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *_image;

@property (strong) NSMutableArray * Cells;
- (IBAction)OnOffSwitch:(id)sender;
@property int locationTypeID;
@property bool isCheck;
@property NSMutableArray *checkedArray;
@end
