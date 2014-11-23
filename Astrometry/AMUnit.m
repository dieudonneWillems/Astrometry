//
//  AMUnit.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMUnit.h"

static NSMutableDictionary *__units;

@interface AMUnit (private)
+ (void) addDefaultUnits;
@end

@implementation AMUnit

+ (AMUnit*) unitWithName:(NSString*)name {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    return [__units objectForKey:name];
}

+ (void) addDefaultUnits {
    AMUnit *radian = [[AMUnit alloc] initSingularBaseUnitWithName:@"radian" andSymbol:@"rad"];
    (void) [[AMUnit alloc] initSingularUnitWithName:@"degree" symbol:@"°" definitionUnit:radian andDefinitionFactor:M_PI/180.];
    (void)[[AMUnit alloc] initSingularBaseUnitWithName:@"magnitude" andSymbol:@""];
}

- (id) initSingularBaseUnitWithName:(NSString*)name andSymbol:(NSString*)symbol {
    self = [super init];
    if(self){
        _name = name;
        _symbol = symbol;
        _type = AMSingularUnit;
        _factor = 1;
        _offset = 0;
        _unit1 = nil;
        _unit2 = nil;
        [__units setObject:self forKey:name];
    }
    return self;
}

- (id) initSingularUnitWithName:(NSString*)name symbol:(NSString*)symbol definitionUnit:(AMUnit*)definitionUnit andDefinitionFactor:(double)fact {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _unit1 = definitionUnit;
        _factor = fact;
    }
    return self;
}

- (id) initUnitMultipleOrSubmultipleWithName:(NSString*)name symbol:(NSString*)symbol baseUnit:(AMUnit*)baseunit andMultipleFactor:(double)fact {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMUnitMultipleOrSubMultiple;
        _unit1 = baseunit;
        _factor = fact;
    }
    return self;
}

- (id) initUnitMultiplicationWithName:(NSString*)name symbol:(NSString*)symbol firstMultiplicationUnit:(AMUnit*)term1 andSecondMultiplicationUnit:(AMUnit*)term2 {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMUnitMultiplication;
        _unit1 = term1;
        _unit2 = term2;
    }
    return self;
}

- (id) initUnitDivisionWithName:(NSString*)name symbol:(NSString*)symbol numerator:(AMUnit*)numerator andDenominator:(AMUnit*)denominator {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMUnitDivision;
        _unit1 = numerator;
        _unit2 = denominator;
    }
    return self;
}

- (id) initUnitExponentiationWithName:(NSString*)name symbol:(NSString*)symbol baseUnit:(AMUnit*)base andExponent:(double)exponent {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMUnitExponentiation;
        _unit1 = base;
        _factor = exponent;
    }
    return self;
}

- (id) initRatioScaleWithName:(NSString*)name andSymbol:(NSString*)symbol {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMRatioScale;
    }
    return self;
}

- (id) initIntervalScaleWithName:(NSString*)name symbol:(NSString*)symbol baseScale:(AMUnit*)baseScale factor:(double)factor andOffset:(double)offset {
    if(!__units){
        __units = [NSMutableDictionary dictionary];
        [AMUnit addDefaultUnits];
    }
    self = [self initSingularBaseUnitWithName:name andSymbol:symbol];
    if(self){
        _type = AMIntervalScale;
        _unit1 = baseScale;
        _factor = factor;
        _offset = offset;
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self symbol]];
}

@end
