//
//  AMFunctions.m
//  Astrometry
//
//  Created by Don Willems on 20/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMFunctions.h"

@implementation AMFunctions


#pragma mark Unit creation and destruction

AMUnit* AMCreateSingularBaseUnit(NSString *name, NSString *symbol) {
    AMUnit *unit = malloc(sizeof(AMUnit));
    const char *cname = [name cStringUsingEncoding:NSASCIIStringEncoding];
    unit->name = malloc(sizeof(char)*((int)[name length]+1));
    strcpy(unit->name, cname);
    const char *csymbol = [symbol cStringUsingEncoding:NSASCIIStringEncoding];
    unit->symbol = malloc(sizeof(char)*[symbol length]);
    strcpy(unit->symbol, csymbol);
    unit->definition.unit1 = nil;
    unit->definition.unit2 = nil;
    unit->definition.factor = 1;
    unit->definition.offset = 0;
    unit->definition.type = AMSingularUnit;
    return unit;
}

AMUnit* AMCreateSingularUnit(NSString *name, NSString *symbol, AMUnit *baseunit, double factor){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.factor = factor;
    unit->definition.unit1 = baseunit;
    return unit;
}

AMUnit* AMCreateUnitMultipleOrSubMultiple(NSString *name, NSString *symbol, AMUnit *baseunit, double factor){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMUnitMultipleOrSubMultiple;
    unit->definition.factor = factor;
    unit->definition.unit1 = baseunit;
    return unit;
}

AMUnit* AMCreateUnitMultiplication(NSString *name, NSString *symbol, AMUnit *term1, AMUnit *term2){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMUnitMultiplication;
    unit->definition.unit1 = term1;
    unit->definition.unit2 = term2;
    return unit;
}

AMUnit* AMCreateUnitDivision(NSString *name, NSString *symbol, AMUnit *numerator, AMUnit *denominator){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMUnitDivision;
    unit->definition.unit1 = numerator;
    unit->definition.unit2 = denominator;
    return unit;
}

AMUnit* AMCreateUnitExponentiation(NSString *name, NSString *symbol, AMUnit *base, double exponent){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMUnitExponentiation;
    unit->definition.unit1 = base;
    unit->definition.factor = exponent;
    return unit;
}

AMUnit* AMCreateRatioScale(NSString *name, NSString *symbol){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMRatioScale;
    return unit;
}

AMUnit* AMCreateIntervalScale(NSString *name, NSString *symbol, AMUnit *baseScale, double factor,double offset){
    AMUnit* unit = AMCreateSingularBaseUnit(name, symbol);
    unit->definition.type = AMIntervalScale;
    unit->definition.unit1 = baseScale;
    unit->definition.factor = factor;
    unit->definition.offset = offset;
    return unit;
}

void AMFreeUnit(AMUnit *unit){
    free(unit->name);
    free(unit->symbol);
    unit->definition.unit1 = nil;
    unit->definition.unit2 = nil;
    free(unit);
}


#pragma mark Quantity creation and destruction

AMQuantity* AMCreateQuantity(NSString *name, NSString *symbol) {
    AMQuantity *quantity = malloc(sizeof(AMQuantity));
    const char *cname = [name cStringUsingEncoding:NSASCIIStringEncoding];
    quantity->name = malloc(sizeof(char)*((int)[name length]+1));
    strcpy(quantity->name, cname);
    const char *csymbol = [symbol cStringUsingEncoding:NSASCIIStringEncoding];
    quantity->symbol = malloc(sizeof(char)*[symbol length]);
    strcpy(quantity->symbol, csymbol);
    return quantity;
}

void AMFreeQuantity(AMQuantity *quantity){
    free(quantity->name);
    free(quantity->symbol);
    free(quantity);
}


#pragma mark Measure creation

AMMeasure* AMCreateMeasure(AMQuantity *quantity, double numericalValue, AMUnit *unit){
    AMMeasure *measure = malloc(sizeof(AMMeasure));
    measure->quantity = quantity;
    measure->numericalValue = numericalValue;
    measure->unit = unit;
    measure->positiveError = 0;
    measure->negativeError = 0;
    return measure;
}

AMMeasure* AMCreateMeasureWithError(AMQuantity *quantity, double numericalValue, double error, AMUnit *unit){
    AMMeasure *measure = AMCreateMeasure(quantity, numericalValue, unit);
    measure->positiveError = error;
    measure->negativeError = error;
    return measure;
}

AMMeasure* AMCreateMeasureWithPositiveAndNegativeError(AMQuantity *quantity, double numericalValue, double poserror,double negerror, AMUnit *unit){
    AMMeasure* measure = AMCreateMeasure(quantity, numericalValue, unit);
    measure->positiveError = poserror;
    measure->negativeError = negerror;
    return measure;
}

void AMFreeMeasure(AMMeasure *measure){
    free(measure);
}


#pragma mark Spherical Coordinates creation and destruction

AMSphericalCoordinates* AMCreateSphericalCoordinates(AMCoordinateSystem coordinateSystem,AMMeasure *longitude,AMMeasure *latitude,AMMeasure *distance){
    AMSphericalCoordinates *coordinates = malloc(sizeof(AMSphericalCoordinates));
    coordinates->coordinateSystem = coordinateSystem;
    coordinates->longitude = longitude;
    coordinates->latitude = latitude;
    coordinates->distance = distance;
    return coordinates;
}

void AMFreeSphericalCoordinates(AMSphericalCoordinates *coordinates){
    free(coordinates);
}


#pragma mark Property key creation and destruction

AMPropertyKey* AMCreatePropertyKey(NSString* keyName){
    AMPropertyKey *key = malloc(sizeof(AMPropertyKey));
    const char *cname = [keyName cStringUsingEncoding:NSASCIIStringEncoding];
    key->key = malloc(sizeof(char)*((int)[keyName length]+1));
    strcpy(key->key, cname);
    return key;
}

void AMFreePropertyKey(AMPropertyKey* key){
    free(key->key);
    free(key);
}


#pragma mark Property creation and destruction

AMStringProperty* AMCreateProperty(AMPropertyKey* key, NSString* value){
    AMStringProperty *property = malloc(sizeof(AMStringProperty));
    property->key = key;
    const char *cname = [value cStringUsingEncoding:NSASCIIStringEncoding];
    property->value = malloc(sizeof(char)*((int)[value length]+1));
    strcpy(property->value, cname);
    return property;
}

void AMFreeProperty(AMStringProperty* property){
    property->key = NULL;
    free(property->value);
    free(property);
}


#pragma mark Celestial Object creation and destruction

AMCelestialObject* AMCreateCelestialObject() {
    AMCelestialObject *celestialObject = malloc(sizeof(AMCelestialObject));
    celestialObject->position = NULL;
    celestialObject->properties = NULL;
    celestialObject->nproperties = 0;
    celestialObject->measures = NULL;
    celestialObject->nmeasures = 0;
    return celestialObject;
}

void AMAddPropertyToCelectialObject(AMCelestialObject* celestialObject,AMPropertyKey *key,NSString *value) {
    if(celestialObject->nproperties==0) celestialObject->properties = (AMStringProperty**)malloc(sizeof(AMStringProperty*));
    else celestialObject->properties = (AMStringProperty**)realloc(celestialObject->properties, (celestialObject->nproperties+1)*sizeof(AMStringProperty*));
    celestialObject->properties[celestialObject->nproperties] = AMCreateProperty(key, value);
    celestialObject->nproperties = celestialObject->nproperties+1;
}

void AMAddMeasureToCelestialObject(AMCelestialObject* celestialObject, AMMeasure *measure) {
    if(celestialObject->nmeasures==0) celestialObject->measures = (AMMeasure**)malloc(sizeof(AMMeasure*));
    else celestialObject->measures = (AMMeasure**)realloc(celestialObject->measures, (celestialObject->nmeasures+1)*sizeof(AMMeasure*));
    celestialObject->measures[celestialObject->nmeasures] = measure;
    celestialObject->nmeasures = celestialObject->nmeasures+1;
}

void AMFreeCelestialObject(AMCelestialObject *celestialObject) {
    int i;
    for(i=0;i<celestialObject->nproperties;i++){
        
    }
    if(celestialObject->properties) free(celestialObject->properties);
    celestialObject->properties = NULL;
    celestialObject->nproperties = 0;
    for(i=0;i<celestialObject->nmeasures;i++){
        AMFreeMeasure(celestialObject->measures[i]);
    }
    if(celestialObject->measures) free(celestialObject->measures);
    celestialObject->measures = NULL;
    celestialObject->nmeasures = 0;
    if(celestialObject->position) AMFreeSphericalCoordinates(celestialObject->position);
}


#pragma mark String functions - creating strings from data types

NSString* NSStringFromUnit(AMUnit unit){
    return [NSString stringWithFormat:@"%s",unit.symbol];
}

NSString* NSStringFromQuantity(AMQuantity quantity){
    return [NSString stringWithFormat:@"%s",quantity.symbol];
}

NSString* NSStringFromDoubleValueWithPrecission(double value,double precission){
    double vlog = log10(value);
    double elog = log10(precission);
    if(vlog<elog) return @"0";
    if(elog>0 || vlog<-2){
        double v = value/pow(10,(int)vlog);
        NSString *format = [NSString stringWithFormat:@"%%.%dfE%d",((int)vlog-(int)elog),(int)vlog];
        return [NSString stringWithFormat:format,v];
    }
    return @"";
}

NSString* NSStringFromDoubleValue(double value, double positiveError, double negativeError)
{
    NSString *sign = @"";
    if(value<0) {
        sign = @"-";
        value = -value;
    }
    positiveError = fabs(positiveError);
    negativeError = fabs(negativeError);
    double error = positiveError;
    if(positiveError>negativeError) error = negativeError;
    double vlog = log10(value);
    double elog = log10(error);
    if(vlog<elog) return @"0";
    if(elog>0 || vlog<-2){
        int vv = (int) vlog;
        if(vv<0) vv=vv-1;
        double v = value/pow(10,vv);
        double pe = positiveError/pow(10,vv);
        int nfrac =((int)vlog-(int)elog);
        NSString *format = nil;
        if(positiveError==negativeError){
            format = [NSString stringWithFormat:@"%@%%.%df±%%.%dfE%d",sign,nfrac,nfrac,vv];
            return [NSString stringWithFormat:format,v,pe];
        }else {
            double ne = negativeError/pow(10,vv);
            format = [NSString stringWithFormat:@"%@%%.%df+%%.%df-%%.%dfE%d",sign,nfrac,nfrac,nfrac,vv];
            return [NSString stringWithFormat:format,v,pe,ne];
        }
    }
    int nfrac = abs((int)elog);
    if(elog<0) nfrac++;
    NSString *format = nil;
    if(positiveError==negativeError){
        format = [NSString stringWithFormat:@"%@%%.%df±%%.%df",sign,nfrac,nfrac];
        return [NSString stringWithFormat:format,value,positiveError];
    }else {
        format = [NSString stringWithFormat:@"%@%%.%df+%%.%df-%%.%df",sign,nfrac,nfrac,nfrac];
        return [NSString stringWithFormat:format,value,positiveError,negativeError];
    }
    return @"";
}

NSString* NSStringFromMeasure(AMMeasure measure){
    if(measure.positiveError == 0 && measure.negativeError==0){
        return [NSString stringWithFormat:@"%@ = %f %@",NSStringFromQuantity(*measure.quantity),measure.numericalValue,NSStringFromUnit(*measure.unit)];
    }
    return [NSString stringWithFormat:@"%@ = %@ %@",
            NSStringFromQuantity(*measure.quantity),
            NSStringFromDoubleValue(measure.numericalValue, measure.positiveError, measure.negativeError),
            NSStringFromUnit(*measure.unit)];
}

NSString* NSStringFromProperty(AMStringProperty* property) {
    return [NSString stringWithFormat:@"%s = %s",property->key->key,property->value];
}

NSString* NSStringFromSphericalCoordinates(AMSphericalCoordinates coordinates){
    if(coordinates.distance==NULL){
        return [NSString stringWithFormat:@"(%@,%@)",NSStringFromMeasure(*coordinates.longitude),NSStringFromMeasure(*coordinates.latitude)];
    }
    return [NSString stringWithFormat:@"(%@,%@,%@)",NSStringFromMeasure(*coordinates.longitude),NSStringFromMeasure(*coordinates.latitude),NSStringFromMeasure(*coordinates.distance)];
}

NSString* NSStringFromCelestialObject(AMCelestialObject object){
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"CelestialObject ["];
    NSInteger i;
    for(i=0;i<object.nproperties;i++){
        [string appendString:NSStringFromProperty(object.properties[i])];
        if(i<object.nproperties-1) [string appendString:@", "];
    }
    if(object.nproperties>0 && object.nmeasures>0) [string appendString:@", "];
    for(i=0;i<object.nmeasures;i++){
        [string appendString:NSStringFromMeasure(*object.measures[i])];
        if(i<object.nmeasures-1) [string appendString:@", "];
    }
    [string appendString:@"]"];
    return string;
}

@end
