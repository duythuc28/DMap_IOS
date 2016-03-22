//
//  FilterTableCell.m
//  MapGoogle
//
//  Created by apple on 10/14/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "FilterTableCell.h"
#import "AppDelegate.h"
#import "LocationType.h"

@implementation FilterTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)OnOffSwitch:(id)sender {
    if (self.typeSwitch.on)
    {
        [_checkedArray addObject:[NSNumber numberWithInt:_locationTypeID]];
    }
    else
    {
        for(NSNumber * number in _checkedArray){
            if([number intValue] == _locationTypeID){
                [_checkedArray removeObject:number];
                break;
            }
        }
        
    }
}
@end
