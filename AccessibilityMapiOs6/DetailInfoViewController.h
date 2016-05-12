//
//  DetailInfoViewController.h
//  DMap
//
//  Created by IOSDev on 5/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ViewController.h"

@class DetailInfoViewController;
@protocol DetailInfoViewDelegate <NSObject>
- (void) callButtonClicked;
@end

@interface DetailInfoViewController : ViewController
@property (weak, nonatomic) id <DetailInfoViewDelegate> delegate;
@property (strong, nonatomic) Location * currentLocation;

- (void) displayDetailInfo:(NSString *)title address:(NSString *)address phoneNumber : (NSString *)phoneNumber;
@end
