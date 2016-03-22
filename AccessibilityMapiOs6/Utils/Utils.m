//
//  Utils.m
//  DMap
//
//  Created by MC976 on 9/6/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"
#import "LocalizeHelper.h"
@implementation Utils
+ (BOOL)checkInternetConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}
@end
