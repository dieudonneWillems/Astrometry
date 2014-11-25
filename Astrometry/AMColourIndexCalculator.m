//
//  AMColourIndexCalculator.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMColourIndexCalculator.h"
#import "AMCelestialObject.h"
#import "AMMeasure.h"
#import "AMQuantity.h"
#import "AMScalarMeasure.h"

@interface AMColourIndexCalculator (private)
- (AMScalarMeasure*) colourIndex:(AMQuantity*)colourIndexQuantity forObject:(AMCelestialObject*)object magnitudeQuantities:(AMQuantity*)mq1 and:(AMQuantity*)mq2;
@end

@implementation AMColourIndexCalculator

- (id) init {
    self = [super init];
    if(self){
        
    }
    return self;
}

- (id) initWithColourIndex:(AMQuantity*)colourIndexQuantity magnitudeQuantities:(AMQuantity*)mag1 and:(AMQuantity*)mag2 {
    self = [super init];
    if(self){
        ciquantity = colourIndexQuantity;
        _mag1 = mag1;
        _mag2 = mag2;
    }
    return self;
}

- (AMMeasure*) calculateMeasureForCelestialObject:(AMCelestialObject*)object {
    if(_mag1 && _mag2){
        return [self colourIndex:ciquantity forObject:object magnitudeQuantities:_mag1 and:_mag2];
    }else {
        return [self colourIndex:[AMQuantity quantityWithName:@"Colour index B-V"] forObject:object magnitudeQuantities:[AMQuantity quantityWithName:@"B magnitude"] and:[AMQuantity quantityWithName:@"V magnitude"]];
        
    }
    return nil;
}

- (AMScalarMeasure*) colourIndex:(AMQuantity*)colourIndexQuantity forObject:(AMCelestialObject*)object magnitudeQuantities:(AMQuantity*)mq1 and:(AMQuantity*)mq2 {
    AMScalarMeasure *mag1 = (AMScalarMeasure*) [object measureForQuantity:mq1];
    AMScalarMeasure *mag2 = (AMScalarMeasure*) [object measureForQuantity:mq2];
    if(mag1 && mag2){
        double cindex = [mag1 value]-[mag2 value];
        double poserr = [mag1 positiveError] + [mag2 negativeError];
        double negerr = [mag1 negativeError] + [mag2 positiveError];
        AMScalarMeasure *colourindex = [[AMScalarMeasure alloc] initWithQuantity:colourIndexQuantity numericalValue:cindex positiveError:poserr negativeError:negerr andUnit:[mag1 unit]];
        return colourindex;
    }
    return nil;
}

@end
