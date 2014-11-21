//
//  AMFunctions.h
//  Astrometry
//
//  Created by Don Willems on 20/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMFunctions : NSObject

#pragma mark Unit creation and destruction

void AMCreateSingularBaseUnit(AMUnit *unit, NSString *name, NSString *symbol);

void AMCreateSingularUnit(AMUnit *unit, NSString *name, NSString *symbol,AMUnit *baseunit, double factor);

void AMCreateUnitMultipleOrSubMultiple(AMUnit *unit, NSString *name, NSString *symbol, AMUnit *baseunit, double factor);

void AMCreateUnitMultiplication(AMUnit *unit, NSString *name, NSString *symbol, AMUnit *term1, AMUnit *term2);

void AMCreateUnitExponentiation(AMUnit *unit, NSString *name, NSString *symbol, AMUnit *base, double exponent);

void AMCreateRatioScale(AMUnit *unit, NSString *name, NSString *symbol);

void AMCreateIntervalScale(AMUnit *unit, NSString *name, NSString *symbol, AMUnit *baseScale, double factor,double offset);

void AMFreeUnit(AMUnit *unit);


#pragma mark Quantity creation and destruction

void AMCreateQuantity(AMQuantity *quantity, NSString *name, NSString *symbol);

void AMFreeQuantity(AMQuantity *quantity);


#pragma mark Measure creation and destruction

void AMCreateMeasure(AMMeasure *measure,AMQuantity *quantity, double numericalValue, AMUnit *unit);

void AMCreateMeasureWithError(AMMeasure *measure,AMQuantity *quantity, double numericalValue, double error, AMUnit *unit);

void AMCreateMeasureWithPositiveAndNegativeError(AMMeasure *measure,AMQuantity *quantity, double numericalValue, double poserror,double negerror, AMUnit *unit);

void AMFreeMeasure(AMMeasure *measure);


#pragma mark String functions - creating strings from data types

NSString* NSStringFromUnit(AMUnit unit);

NSString* NSStringFromQuantity(AMQuantity quantity);

NSString* NSStringFromMeasure(AMMeasure measure);

@end
