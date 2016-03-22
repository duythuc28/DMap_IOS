//
//  LocationType.h
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationType : NSManagedObject

@property (nonatomic, retain) NSNumber * locationTypeID;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * locationImageLink;
@property (nonatomic, retain) NSNumber * isCheck;
@property (nonatomic, retain) NSString * locationName_en;
+ (NSArray *) getAllData;
+ (NSArray *) getAllDataByEn;
//+ (LocationType *) getAllDataByLocType;

+ (void) insert:(id)locationType;
+ (void) removeAllData;

+ (LocationType*)getLocationTypeById:(int)locationId;
//+ (void) checkSwitchState:(int)locationId;
+ (NSArray *)getCheckData;
+ (UIImage*) getImageByLocationTypeId:(int)locationId;
+ (void) insertWithCheck:(id)locationType;
+ (void) editObject:(id)editObjectId fromObject:(id)fromObjectId;
@end
