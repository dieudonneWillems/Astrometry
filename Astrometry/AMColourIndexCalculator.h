//
//  AMColourIndexCalculator.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMCalculator.h"

@class AMQuantity;

@interface AMColourIndexCalculator : AMCalculator {
    AMQuantity *_mag1;
    AMQuantity *_mag2;
    AMQuantity *ciquantity;
}

- (id) init;
- (id) initWithColourIndex:(AMQuantity*)colourIndexQuantity magnitudeQuantities:(AMQuantity*)mag1 and:(AMQuantity*)mag2;

@end
