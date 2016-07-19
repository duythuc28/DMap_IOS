//
//  Bookmark.h
//  MapGoogle
//
//  Created by apple on 9/25/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationType.h"
@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * locationID;
@property (nonatomic, retain) NSNumber * isBookmark;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longtitude;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *location_AccessType;
@property (nonatomic, retain) LocationType *location_LocationType;

+ (NSArray *) getAllData;
+ (NSArray *) getDataWithPos: (NSString*) latitude andWithLong:(NSString*) longtitude;
+ (NSArray *) getDataWithCurrentZoomPos:(CLLocation*)zoomPos withDistanceInKilomiter:(int)distance;

+ (NSArray *) getDataById:(int)locationID;
+ (void) deleteDataWithArray: (NSArray*) array;
+ (void) insert:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType;
+ (void) insertWithCheck:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType;
+ (void) editObject:(id)editObjectId byBookmark:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType;
+ (void) bookmarkTheMarker:(GMSMarker*)pos;
+ (void) removeBookmarkTheMarker:(id)pos;
+ (NSArray *) getBookmarkedData;
+ (void) deleteDataWithLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude;
+ (NSArray *) getLocationByName: (NSString*)name;
+ (void) setFavoriteLocation:(Location*)location isFavorite:(BOOL) isFavorite;
@end
