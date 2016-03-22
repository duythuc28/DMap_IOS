//
//  GuideTableViewCell.m
//  MapGoogle
//
//  Created by Hackintosh on 10/12/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "GuideTableViewCell.h"

@implementation GuideTableViewCell

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

@end
