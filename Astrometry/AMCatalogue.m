//
//  AMCatalogue.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogue.h"
#import "AMFunctions.h"

@implementation AMCatalogue

- (id) init {
    self = [super init];
    if(self){
        nObjects = 0;
        objects = NULL;
        nProperties = 0;
        properties = NULL;
        nQuantities = 0;
        quantities = NULL;
    }
    return self;
}

- (void) dealloc {
    if(objects!=NULL){
        NSInteger i;
        for(i=0;i<nObjects;i++){
            AMFreeCelestialObject(objects[i]);
        }
        free(objects);
    }
}

- (void) addCelestialObject:(AMCelestialObject*)object {
    
}

- (NSString *) description {
    NSString * str = [NSString stringWithFormat:@"CATALOGUE: %@ %ld objects\n%@",[self name],nObjects,[self catalogueDescription]];
    return str;
}
@end
