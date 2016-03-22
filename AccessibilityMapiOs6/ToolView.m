//
//  ToolView.m
//  DMap
//
//  Created by MC976 on 5/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "ToolView.h"
#import "LocalizeHelper.h"
@implementation ToolView

-(void)awakeFromNib
{
    int radius = [[[NSUserDefaults standardUserDefaults]objectForKey:@"radius"]intValue];
    self.sliderRange.value = radius;
    self.kilometerLable.text = [NSString stringWithFormat:@"%d km",radius];
    [self localizeLanguage];
}

-(void)localizeLanguage {
    [self.selectPlaceType setTitle:LocalizedString(@"Place Category") forState:UIControlStateNormal];
    [self.updateDatabaseButton setTitle:LocalizedString(@"Update Database") forState:UIControlStateNormal];
    [self.aboutButton setTitle:LocalizedString(@"About") forState:UIControlStateNormal];
    [self.helpButton setTitle:LocalizedString(@"Help") forState:UIControlStateNormal];
    [self.doneButton setTitle:LocalizedString(@"Done") forState:UIControlStateNormal];
}

@end
