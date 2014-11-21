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
    const char *cname = [name cStringUsingEncoding:NSUTF8StringEncoding];
    unit->name = malloc(sizeof(char)*((int)[name length]+1));
    strcpy(unit->name, cname);
    const char *csymbol = [symbol cStringUsingEncoding:NSUTF8StringEncoding];
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

void AMCreateQuantity(AMQuantity *quantity, NSString *name, NSString *symbol) {
    const char *cname = [name cStringUsingEncoding:NSUTF8StringEncoding];
    quantity->name = malloc(sizeof(char)*((int)[name length]+1));
    strcpy(quantity->name, cname);
    const char *csymbol = [symbol cStringUsingEncoding:NSUTF8StringEncoding];
    quantity->symbol = malloc(sizeof(char)*[symbol length]);
    strcpy(quantity->symbol, csymbol);
}

void AMFreeQuantity(AMQuantity *quantity){
    free(quantity->name);
    free(quantity->symbol);
    free(quantity);
}


#pragma mark Measure creation

void AMCreateMeasure(AMMeasure *measure,AMQuantity *quantity, double numericalValue, AMUnit *unit){
    measure->quantity = quantity;
    measure->numericalValue = numericalValue;
    measure->unit = unit;
    measure->positiveError = 0;
    measure->negativeError = 0;
}

void AMCreateMeasureWithError(AMMeasure *measure,AMQuantity *quantity, double numericalValue, double error, AMUnit *unit){
    AMCreateMeasure(measure, quantity, numericalValue, unit);
    measure->positiveError = error;
    measure->negativeError = error;
}

void AMCreateMeasureWithPositiveAndNegativeError(AMMeasure *measure,AMQuantity *quantity, double numericalValue, double poserror,double negerror, AMUnit *unit){
    AMCreateMeasure(measure, quantity, numericalValue, unit);
    measure->positiveError = poserror;
    measure->negativeError = negerror;
}

void AMFreeMeasure(AMMeasure *measure){
    free(measure);
}


#pragma mark Spherical Coordinates creation and destruction

void AMCreateSphericalCoordinates(AMSphericalCoordinates *coordinates,AMCoordinateSystem coordinateSystem,AMMeasure *longitude,AMMeasure *latitude,AMMeasure *distance){
    coordinates->coordinateSystem = coordinateSystem;
    coordinates->longitude = longitude;
    coordinates->latitude = latitude;
    coordinates->distance = distance;
}

void AMFreeSphericalCoordinates(AMSphericalCoordinates *coordinates){
    free(coordinates);
}


#pragma mark String functions - creating strings from data types

NSString* NSStringFromUnit(AMUnit unit){
    return [NSString stringWithFormat:@"%s",unit.symbol];
}

NSString* NSStringFromQuantity(AMQuantity quantity){
    return [NSString stringWithFormat:@"%s",quantity.symbol];
}

NSString* NSStringFromDoubleValueWithPrecission(double value,double precission)
{
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

NSString* NSStringFromSphericalCoordinates(AMSphericalCoordinates coordinates){
    if(coordinates.distance==NULL){
        return [NSString stringWithFormat:@"(%@,%@)",NSStringFromMeasure(*coordinates.longitude),NSStringFromMeasure(*coordinates.latitude)];
    }
    return [NSString stringWithFormat:@"(%@,%@,%@)",NSStringFromMeasure(*coordinates.longitude),NSStringFromMeasure(*coordinates.latitude),NSStringFromMeasure(*coordinates.distance)];
}

@end
