//
//  AMCatalogue.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogue.h"
#import "AMCelestialObject.h"

@implementation AMCatalogue

- (id) init {
    self = [super init];
    if(self){
        objects = [NSMutableArray array];
        quantities = [NSMutableArray array];
        properties = [NSMutableArray array];
    }
    return self;
}

- (void) addCelestialObject:(AMCelestialObject*)object {
    [objects addObject:object];
    NSArray *measures = [object measures];
}

- (NSString *) description {
    NSString * str = [NSString stringWithFormat:@"CATALOGUE: %@ %ld objects\n%@",[self name],[objects count],[self catalogueDescription]];
    return str;
}
@end
