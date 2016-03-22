//
//  AppDelegate.h
//  AccessibilityMapiOs6
//
//  Created by apple on 10/2/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel         *           managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext       *         managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *   persistentStoreCoordinator;

@end
