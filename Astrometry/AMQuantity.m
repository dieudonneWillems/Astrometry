//
//  AMQuantity.m
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMQuantity.h"
#import "AMScalarQuantity.h"
#import "AMVectorQuantity.h"

static NSMutableDictionary *__quantities;

@interface AMQuantity (private)
+ (void) addDefaultQuantities;
@end

@implementation AMQuantity

+ (AMQuantity*) quantityWithName:(NSString*)name {
    if(!__quantities){
        __quantities = [[NSMutableDictionary alloc] init];
        [AMQuantity addDefaultQuantities];
    }
    return [__quantities objectForKey:name];
}

+ (void) addDefaultQuantities {
    (void) [[AMScalarQuantity alloc] initWithName:@"U magnitude" andSymbol:@"U"];
    (void) [[AMScalarQuantity alloc] initWithName:@"B magnitude" andSymbol:@"B"];
    (void) [[AMScalarQuantity alloc] initWithName:@"V magnitude" andSymbol:@"V"];
    (void) [[AMScalarQuantity alloc] initWithName:@"R magnitude" andSymbol:@"R"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Colour index B-R" andSymbol:@"B-R"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Colour index B-V" andSymbol:@"B-V"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Right ascension" andSymbol:@"α"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Declination" andSymbol:@"δ"];
    (void) [[AMVectorQuantity alloc] initWithName:@"Spherical position" andSymbol:@""];
}

- (id) initWithName:(NSString*)name andSymbol:(NSString*)symbol {
    if(!__quantities){
        __quantities = [[NSMutableDictionary alloc] init];
        [AMQuantity addDefaultQuantities];
    }
    self = [super init];
    if(self){
        _name = name;
        _symbol = symbol;
        [__quantities setObject:self forKey:name];
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self symbol]];
}

@end
