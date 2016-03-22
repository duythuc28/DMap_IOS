//
//  LocationTabBarController.h
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
@interface LocationTabBarController : UITabBarController

@property (strong, nonatomic) Location* locationInfo;

@property(strong) UIViewController*rootViewController;
@property(strong) UIBarButtonItem *flipButton;
-(void)toggleBarButton:(bool)show;
@end
