//
//  AMUnit.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTypes.h"

@interface AMUnit : NSObject

+ (AMUnit*) unitWithName:(NSString*)name;

- (id) initSingularBaseUnitWithName:(NSString*)name andSymbol:(NSString*)symbol;
- (id) initSingularUnitWithName:(NSString*)name symbol:(NSString*)symbol definitionUnit:(AMUnit*)definitionUnit andDefinitionFactor:(double)fact;
- (id) initUnitMultipleOrSubmultipleWithName:(NSString*)name symbol:(NSString*)symbol baseUnit:(AMUnit*)baseunit andMultipleFactor:(double)fact;
- (id) initUnitMultiplicationWithName:(NSString*)name symbol:(NSString*)symbol firstMultiplicationUnit:(AMUnit*)term1 andSecondMultiplicationUnit:(AMUnit*)term2;
- (id) initUnitDivisionWithName:(NSString*)name symbol:(NSString*)symbol numerator:(AMUnit*)numerator andDenominator:(AMUnit*)denominator;
- (id) initUnitExponentiationWithName:(NSString*)name symbol:(NSString*)symbol baseUnit:(AMUnit*)base andExponent:(double)exponent;
- (id) initRatioScaleWithName:(NSString*)name andSymbol:(NSString*)symbol;
- (id) initIntervalScaleWithName:(NSString*)name symbol:(NSString*)symbol baseScale:(AMUnit*)baseScale factor:(double)factor andOffset:(double)offset;

@property (readonly) NSString *name;
@property (readonly) NSString *symbol;

@property (readonly) AMUnitType type;
@property (readonly) double factor;
@property (readonly) double offset;
@property (readonly) AMUnit* unit1;
@property (readonly) AMUnit* unit2;

@end
