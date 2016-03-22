//
//  AccessTypes.h
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccessType : NSManagedObject

@property (nonatomic, retain) NSNumber * accessTypeID;
@property (nonatomic, retain) NSString * accessDescribtion;
@property (nonatomic, retain) NSString * accessName;
@property (nonatomic, retain) NSString * accessImageLink;
@property (nonatomic, retain) NSString * accessName_en;
+ (NSArray *) getAllData;
+ (NSArray *) getAllDataByEn;
+ (void) insert:(id)accessType;
+ (void) removeAllData;

+ (AccessType*)getTypeById:(int)typeId;

+ (NSArray *) getDataByIdCodes:(long)idCode;
+ (UIImage *) getImageByAcessTypeID:(int)acTypeCode;
+ (void) editObject:(id)editObjectId fromObject:(id)fromObjectId;
+ (void) insertWithCheck:(id)accessType;

@end
