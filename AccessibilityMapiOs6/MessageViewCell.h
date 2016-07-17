//
//  MessageViewCell.h
//  DMap
//
//  Created by IOSDev on 5/13/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * userPhone;
@property (weak, nonatomic) IBOutlet UILabel * userComment;

- (void)setupCellUserPhone:(NSString *)userPhone
      userComment:(NSString *)userComment;

@end
