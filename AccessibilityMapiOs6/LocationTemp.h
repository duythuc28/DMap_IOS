//
//  LocationTemp.h
//  MapGoogle
//
//  Created by Hackintosh on 10/27/14.
//  Copyright (c) 2014 apple. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LocationTemp : NSManagedObject
@property (nonatomic, retain) NSString * accesstype;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longtitude;
@property (nonatomic, retain) NSNumber * locationtype;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * userphone;
@property (nonatomic, retain) NSNumber * isUser;
+ (NSArray *) getAllData;
+ (NSArray *) getUserData:(NSNumber *)user;
+( NSArray *) getDataByName:(NSString*)name;
+ (void) insert:(id)accessType;
+ (void) removeAllData;
+ (void) removeSaveDataByName:(NSString*)name;
@end
