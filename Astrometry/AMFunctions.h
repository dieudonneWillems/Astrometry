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

AMUnit* AMCreateSingularBaseUnit(NSString *name, NSString *symbol);

AMUnit* AMCreateSingularUnit(NSString *name, NSString *symbol,AMUnit *baseunit, double factor);

AMUnit* AMCreateUnitMultipleOrSubMultiple(NSString *name, NSString *symbol, AMUnit *baseunit, double factor);

AMUnit* AMCreateUnitMultiplication(NSString *name, NSString *symbol, AMUnit *term1, AMUnit *term2);

AMUnit* AMCreateUnitExponentiation(NSString *name, NSString *symbol, AMUnit *base, double exponent);

AMUnit* AMCreateRatioScale(NSString *name, NSString *symbol);

AMUnit* AMCreateIntervalScale(NSString *name, NSString *symbol, AMUnit *baseScale, double factor,double offset);

void AMFreeUnit(AMUnit *unit);


#pragma mark Quantity creation and destruction

AMQuantity* AMCreateQuantity(NSString *name, NSString *symbol);

void AMFreeQuantity(AMQuantity *quantity);


#pragma mark Measure creation and destruction

AMMeasure* AMCreateMeasure(AMQuantity *quantity, double numericalValue, AMUnit *unit);

AMMeasure* AMCreateMeasureWithError(AMQuantity *quantity, double numericalValue, double error, AMUnit *unit);

AMMeasure* AMCreateMeasureWithPositiveAndNegativeError(AMQuantity *quantity, double numericalValue, double poserror,double negerror, AMUnit *unit);

void AMFreeMeasure(AMMeasure *measure);


#pragma mark Spherical Coordinates creation and destruction

AMSphericalCoordinates* AMCreateSphericalCoordinates(AMCoordinateSystem coordinateSystem,AMMeasure *longitude,AMMeasure *latitude,AMMeasure *distance);

void AMFreeSphericalCoordinates(AMSphericalCoordinates *coordinates);


#pragma mark Property key creation and destruction

AMPropertyKey* AMCreatePropertyKey(NSString* keyName);

void AMFreePropertyKey(AMPropertyKey* key);


#pragma mark Property creation and destruction

AMStringProperty* AMCreateProperty(AMPropertyKey* key, NSString* value);

void AMFreeProperty(AMStringProperty* property);


#pragma mark Celestial Object creation and destruction

AMCelestialObject* AMCreateCelestialObject();

void AMAddPropertyToCelectialObject(AMCelestialObject* celestialObject,AMPropertyKey *key,NSString *value);

void AMAddMeasureToCelestialObject(AMCelestialObject* celestialObject, AMMeasure *measure);

void AMFreeCelestialObject(AMCelestialObject *celestialObject);


#pragma mark String functions - creating strings from data types

NSString* NSStringFromUnit(AMUnit unit);

NSString* NSStringFromQuantity(AMQuantity quantity);

NSString* NSStringFromMeasure(AMMeasure measure);

NSString* NSStringFromProperty(AMStringProperty* property);

NSString* NSStringFromSphericalCoordinates(AMSphericalCoordinates coordinates);

NSString* NSStringFromCelestialObject(AMCelestialObject object);

@end
