//
//  ToolView.h
//  DMap
//
//  Created by MC976 on 5/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolView : UIControl
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UISlider *sliderRange;
@property (weak, nonatomic) IBOutlet UILabel *kilometerLable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSelected;
@property (weak, nonatomic) IBOutlet UIButton *selectPlaceType;
@property (weak, nonatomic) IBOutlet UIButton *updateDatabaseButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@end
