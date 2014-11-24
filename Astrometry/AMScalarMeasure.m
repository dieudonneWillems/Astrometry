//
//  AMScalarMeasure.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMScalarMeasure.h"
#import "AMUnit.h"

@interface AMScalarMeasure (private)
- (NSString*) stringFromDoubleValue:(double)value positiveError:(double)positiveError negativeError:(double)negativeError;
@end

@implementation AMScalarMeasure

- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value andUnit:(AMUnit*)unit {
    self = [self initWithQuantity:quantity numericalValue:value positiveError:0. negativeError:0. andUnit:unit];
    return self;
}

- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value error:(double)error andUnit:(AMUnit*)unit {
    self = [self initWithQuantity:quantity numericalValue:value positiveError:error negativeError:error andUnit:unit];
    return self;
}

- (id) initWithQuantity:(AMQuantity*)quantity numericalValue:(double)value positiveError:(double)positiveError negativeError:(double)negativeError andUnit:(AMUnit*)unit {
    self = [super initWithQuantity:quantity];
    if(self){
        _value = value;
        _positiveError = positiveError;
        _negativeError = negativeError;
        _unit = unit;
    }
    return self;
}


- (NSString*) stringFromDoubleValue:(double)value positiveError:(double)positiveError negativeError:(double)negativeError {
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

- (NSComparisonResult) ignoreErrorsCompare:(AMMeasure*)measure {
    // todo unit conversion
    if([measure isKindOfClass:[AMScalarMeasure class]]){
        AMScalarMeasure *scmeas = (AMScalarMeasure*)measure;
        if([self value]<[scmeas value]) return NSOrderedAscending;
        if([self value]>[scmeas value]) return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (NSComparisonResult) compare:(AMMeasure*)measure {
    // todo unit conversion
    return [self ignoreErrorsCompare:measure];
}

- (NSString*) description {
    if([self positiveError] == 0 && [self negativeError]==0){
        return [NSString stringWithFormat:@"%@ = %f%@",[self quantity],[self value],[self unit]];
    }
    return [NSString stringWithFormat:@"%@ = %@%@",[self quantity],
            [self stringFromDoubleValue:[self value] positiveError:[self positiveError] negativeError:[self negativeError]],[self unit]];
}
@end
