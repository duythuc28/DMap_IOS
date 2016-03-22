//
//  LocationType.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "LocationType.h"
#import "AppDelegate.h"

@implementation LocationType

@dynamic locationTypeID;
@dynamic locationName;
@dynamic locationImageLink;
@dynamic isCheck;
@dynamic locationName_en;

+ (NSArray*)getAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"locationName" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *)getAllDataByEn
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"locationName_en" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}
/*
 + (LocationType *) getAllDataByLocType
 {
 AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
 NSManagedObjectContext *context = [appDelegate managedObjectContext];
 
 NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
 [fetch setReturnsObjectsAsFaults:NO];
 [fetch setEntity:[NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context]];
 NSError *fetchError;
 NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
 return (LocationType*)[fetchedProducts objectAtIndex:0];
 }*/

+ (void)removeAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray* allData = [LocationType  getAllData];
    for (NSManagedObject *locationType in allData) {
        [context deleteObject:locationType];
    }
}

+ (void)insert:(id)accessType{
    LocationType* willInsert = (LocationType *) accessType;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *locationTypeInfo = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"LocationType"
                                         inManagedObjectContext:context];
    [locationTypeInfo setValue:willInsert.locationTypeID        forKey:@"locationTypeID"];
    [locationTypeInfo setValue:willInsert.locationName          forKey:@"locationName"];
    [locationTypeInfo setValue:willInsert.locationImageLink     forKey:@"locationImageLink"];
    [locationTypeInfo setValue:willInsert.isCheck forKey:@"isCheck"];
    [locationTypeInfo setValue:willInsert.locationName_en forKey:@"locationName_en"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

+ (LocationType*)getLocationTypeById:(int)locationId{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"locationTypeID == %d", locationId];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    if([fetchedProducts count] == 0)
        return nil;
    return (LocationType*)[fetchedProducts objectAtIndex:0];
}
+(NSArray*) getCheckData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"isCheck == YES"];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}
/*
 + (void) checkSwitchState:(int)locationId
 {
 AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
 NSManagedObjectContext *context = [appDelegate managedObjectContext];
 LocationType * getlocid = [LocationType getLocationTypeById:locationId];
 
 
 }*/

+ (UIImage*) getImageByLocationTypeId:(int)locationId{
    LocationType * locationType = [self getLocationTypeById:locationId];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:locationType.locationImageLink];
    UIImage * returnImage = [UIImage imageWithContentsOfFile: path];
    return returnImage;
}

+ (void)insertWithCheck:(id)locationType{
    LocationType * checkedObject = (LocationType*) locationType;
    
    LocationType * check = [LocationType getLocationTypeById:[checkedObject.locationTypeID intValue]];
    
    if(check == nil){
        [self insert:locationType];
    }else{
        [self editObject:check fromObject:locationType];
    }
}
+ (void) editObject:(id)editObjectId fromObject:(id)fromObjectId{
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    LocationType * editObject = (LocationType*)editObjectId;
    LocationType * fromObject = (LocationType*)fromObjectId;
    
    editObject.locationName = fromObject.locationName;
}


@end
