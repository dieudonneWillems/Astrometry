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
    (void) [[AMScalarQuantity alloc] initWithName:@"Longitude" andSymbol:@"l"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Latitude" andSymbol:@"b"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Trigonometric Parallax" andSymbol:@"p"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Poper motion in right ascension" andSymbol:@"mu_α"];
    (void) [[AMScalarQuantity alloc] initWithName:@"Poper motion in declination" andSymbol:@"mu_δ"];
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

- (BOOL) isEqual:(id)object {
    if([object isKindOfClass:[AMQuantity class]]){
        if([[(AMQuantity*)object name] isEqualToString:[self name]]){
            return YES;
        }
    }
    return NO;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self symbol]];
}

@end
