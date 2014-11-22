//
//  AMUnitAndQuantityFactory.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMUnitAndQuantityStack : NSObject {
    AMUnit **units; // sorted array of units;
    NSUInteger nUnits;
    AMQuantity **quantities; // sorted array of quantities
    NSUInteger nQuantities;
}

+ (AMUnitAndQuantityStack*) sharedUnitAndQuantityStack;

- (AMUnit*) unitWithName:(NSString*)name;
- (void) addUnit:(AMUnit*)unit;

- (AMQuantity*) quantityWithName:(NSString*)name;
- (void) addQuantity:(AMQuantity*)quantity;

@end
