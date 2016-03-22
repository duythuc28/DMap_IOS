//
//  LocationTemp.m
//  MapGoogle
//
//  Created by Hackintosh on 10/27/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "LocationTemp.h"
#import "AppDelegate.h"

@implementation LocationTemp

@dynamic accesstype;
@dynamic address;
@dynamic latitude;
@dynamic longtitude;
@dynamic locationtype;
@dynamic title;
@dynamic phone;
@dynamic userphone;
@dynamic isUser;


+ (NSArray*)getAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    //[fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"LocationTemp" inManagedObjectContext:context]];
    [fetch setIncludesPropertyValues:NO];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}
+ (NSArray*)getUserData:(NSNumber *)user
{
    NSMutableArray * returnData = [[NSMutableArray alloc]init];
    NSArray * allData = [self getAllData];
    for (LocationTemp * each in allData)
    {
        [returnData addObject:each];
    }
    return [returnData mutableCopy];
}

+ (NSArray *) getDataByName:(NSString *)name
{
    NSMutableArray * returnData = [[NSMutableArray alloc]init];
    NSArray * allData = [self getAllData];
    for (LocationTemp * each in allData)
    {
        if ([each.title isEqualToString:name])
        {
            [returnData addObject:each];
        }
    }
    return [returnData mutableCopy];
}

+(void)removeSaveDataByName:(NSString *)name
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"LocationTemp" inManagedObjectContext:context]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [context executeFetchRequest:allCars error:&error];
    
    //error handling goes here
    NSMutableArray * returnData = [[NSMutableArray alloc]init];
    for (LocationTemp * each in cars)
    {
        if ([each.title isEqualToString:name])
        {
            [returnData addObject:each];
        }
    }
    
    for (NSManagedObject * car in returnData) {
        [context deleteObject:car];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    /*
    NSArray* allData = [LocationTemp  getDataByName:name];
    
    for (NSManagedObject *accessType in allData) {
        [context deleteObject:accessType];
    }*/

}

+ (void)removeAllData{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"LocationTemp" inManagedObjectContext:context]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [context executeFetchRequest:allCars error:&error];
        //error handling goes here
    for (NSManagedObject * car in cars) {
        [context deleteObject:car];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}




+ (void)insert:(id)accessType{
    LocationTemp* willInsert = (LocationTemp *) accessType;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *accessInfo = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"LocationTemp"
                                   inManagedObjectContext:context];
    [accessInfo setValue:willInsert.accesstype        forKey:@"accesstype"];
    [accessInfo setValue:willInsert.address          forKey:@"address"];
    [accessInfo setValue:willInsert.latitude     forKey:@"latitude"];
    [accessInfo setValue:willInsert.longtitude   forKey:@"longtitude"];
    [accessInfo setValue:willInsert.locationtype        forKey:@"locationtype"];
    [accessInfo setValue:willInsert.title          forKey:@"title"];
    [accessInfo setValue:willInsert.phone     forKey:@"phone"];
    [accessInfo setValue:willInsert.userphone   forKey:@"userphone"];
    [accessInfo setValue:willInsert.isUser forKey:@"isUser"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}



@end
