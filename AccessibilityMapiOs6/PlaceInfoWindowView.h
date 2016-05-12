//
//  PlaceInfoWindowView.h
//  DMap
//
//  Created by MC976 on 3/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopAlignLabel.h"
#import "CustomMarker.h"

@class PlaceInfoWindowView;
@protocol PlaceInfoWindowDelegate <NSObject>
- (void) placeInfoViewClicked:(PlaceInfoWindowView *)placeInfoView;
- (void) closeButtonClicked:(PlaceInfoWindowView *) placeInfoView;
@end

@interface PlaceInfoWindowView : UIView
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet TopAlignLabel *placeTitle;
@property (weak, nonatomic) IBOutlet TopAlignLabel *placeAddress;
@property (weak, nonatomic) IBOutlet UIImageView *placeIcon;
@property (weak, nonatomic) id <PlaceInfoWindowDelegate> delegate;

@property (strong, nonatomic) CustomMarker * customMarker;

- (id)initWithFrame:(CGRect)frame;

- (void)displayView:(CustomMarker *)marker;

@end
