//
//  MDDirectionService.h
//  MapGoogle
//
//  Created by Hackintosh on 9/19/14.
//  Copyright (c) 2014 Hackintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDirectionService : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;

-(void)setDirectionsQueryByBus:(NSDictionary *)query withSelector:(SEL)selector
                  withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end
