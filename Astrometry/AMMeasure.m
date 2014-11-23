//
//  AMMeasure.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMMeasure.h"
#import "AMQuantity.h"

@implementation AMMeasure

- (id) initWithQuantity:(AMQuantity*)quantity {
    self = [super init];
    if(self){
        _quantity = quantity;
    }
    return self;
}

@end
