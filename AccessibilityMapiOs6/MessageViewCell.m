//
//  MessageViewCell.m
//  DMap
//
//  Created by IOSDev on 5/13/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "MessageViewCell.h"

@implementation MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupCell:(NSString *)userPhone userComment:(NSString *)userComment {
    self.userPhone.text = userPhone;
    self.userComment.text = userComment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
