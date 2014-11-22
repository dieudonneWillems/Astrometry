//
//  AMUnitAndQuantityFactory.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMUnitAndQuantityStack.h"
#import "AMFunctions.h"

static AMUnitAndQuantityStack *__sharedUnitAndQuantityFactory;

@interface AMUnitAndQuantityStack (private)
- (void) addDefaultUnitsAndQuantities;
- (NSUInteger) indexOfUnitWithName:(const char*)name startIndex:(NSUInteger)start endIndex:(NSUInteger)endIndex;
- (NSUInteger) indexOfQuantityWithName:(const char*)name startIndex:(NSUInteger)start endIndex:(NSUInteger)endIndex;
@end

@implementation AMUnitAndQuantityStack

+ (AMUnitAndQuantityStack*) sharedUnitAndQuantityStack {
    if(!__sharedUnitAndQuantityFactory){
        __sharedUnitAndQuantityFactory = [[AMUnitAndQuantityStack alloc] init];
    }
    return __sharedUnitAndQuantityFactory;
}

- (id) init {
    self = [super init];
    if(self){
        nUnits = 0;
        units = NULL;
        nQuantities = 0;
        quantities = NULL;
        [self addDefaultUnitsAndQuantities];
    }
    return self;
}

- (void) addDefaultUnitsAndQuantities{
    AMUnit *radian = AMCreateSingularBaseUnit(@"radian", @"rad");
    [self addUnit:radian];
    [self addUnit:AMCreateSingularUnit(@"degree",@"°", radian, M_PI/180.)];
    AMUnit *magnitude = AMCreateSingularBaseUnit(@"magnitude", @"");
    [self addUnit:magnitude];
    [self addQuantity:AMCreateQuantity(@"Bessel B magnitude", @"B")];
    [self addQuantity:AMCreateQuantity(@"Bessel R magnitude", @"R")];
    [self addQuantity:AMCreateQuantity(@"Right ascension", @"α")];
    [self addQuantity:AMCreateQuantity(@"Declination", @"δ")];
}

- (void) dealloc {
    NSUInteger i;
    for(i=0;i<nUnits;i++){
        AMFreeUnit(units[i]);
    }
    free(units);
    for(i=0;i<nQuantities;i++){
        AMFreeQuantity(quantities[i]);
    }
    free(quantities);
}

- (AMUnit*) unitWithName:(NSString*)name {
    NSUInteger index = [self indexOfUnitWithName:[name cStringUsingEncoding:NSUTF8StringEncoding] startIndex:0 endIndex:nUnits];
    AMUnit *unit = units[index];
    if(strcmp(unit->name,[name cStringUsingEncoding:NSUTF8StringEncoding])!=0) return NULL;
    return unit;
}

- (NSUInteger) indexOfUnitWithName:(const char*)name startIndex:(NSUInteger)start endIndex:(NSUInteger)end {
    if(start==end) return start;
    NSUInteger pos = start + (end - start)/2;
    if(pos>=nUnits) return nUnits;
    int cmp = strcmp(name, units[pos]->name);
    if(cmp<0) return [self indexOfUnitWithName:name startIndex:start endIndex:pos];
    if(cmp>0) return [self indexOfUnitWithName:name startIndex:pos+1 endIndex:end];
    return pos;
}

- (void) addUnit:(AMUnit*)unit {
    NSUInteger index = [self indexOfUnitWithName:unit->name startIndex:0 endIndex:nUnits];
    if(!units || index==nUnits || strcmp(unit->name,units[index]->name)!=0) {
        nUnits = nUnits+1;
        if(nUnits==1) units = (AMUnit**)malloc(sizeof(AMUnit*));
        else units = (AMUnit**)realloc(units, sizeof(nUnits*sizeof(AMUnit*)));
        NSUInteger tc;
        for(tc = nUnits-1;tc>index;tc--){
            units[tc] = units[tc-1];
        }
        units[index] = unit;
    }
}

- (AMQuantity*) quantityWithName:(NSString*)name {
    NSUInteger index = [self indexOfQuantityWithName:[name cStringUsingEncoding:NSUTF8StringEncoding] startIndex:0 endIndex:nUnits];
    AMQuantity *quantity = quantities[index];
    if(strcmp(quantity->name,[name cStringUsingEncoding:NSUTF8StringEncoding])!=0) return NULL;
    return quantity;
}

- (void) addQuantity:(AMQuantity*)quantity {
    NSUInteger index = [self indexOfQuantityWithName:quantity->name startIndex:0 endIndex:nUnits];
    if(!quantities || index==nQuantities || strcmp(quantities[index]->name,quantity->name)!=0) {
        nQuantities = nQuantities+1;
        if(nQuantities==1) quantities = (AMQuantity**)malloc(sizeof(AMQuantity*));
        else quantities = (AMQuantity**)realloc(quantities, sizeof(nQuantities*sizeof(AMQuantity*)));
        NSUInteger tc;
        for(tc = nQuantities-1;tc>index;tc--){
            quantities[tc] = quantities[tc-1];
        }
        quantities[index] = quantity;
    }
}

- (NSUInteger) indexOfQuantityWithName:(const char*)name startIndex:(NSUInteger)start endIndex:(NSUInteger)end {
    if(start==end) return start;
    NSUInteger pos = start + (end - start)/2;
    if(pos>=nQuantities) return nQuantities;
    int cmp = strcmp(name, quantities[pos]->name);
    if(cmp<0) return [self indexOfUnitWithName:name startIndex:start endIndex:pos];
    if(cmp>0) return [self indexOfUnitWithName:name startIndex:pos+1 endIndex:end];
    return pos;
}

@end
