//
//  AMCompoundSearchDescriptor.m
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCompoundSearchDescriptor.h"

@implementation AMCompoundSearchDescriptor

- (id) initWithOperator:(AMCompoundSearchOperator)searchOperator {
    self = [super init];
    if(self){
        _searchOperator = searchOperator;
    }
    return self;
}

- (id) initWithOperator:(AMCompoundSearchOperator)searchOperator searchDescriptors:(AMSearchDescriptor*)firstDescriptor,... {
    self = [super init];
    if(self){
        _searchOperator = searchOperator;
        subDescriptors = [NSMutableArray array];
        va_list args;
        va_start(args, firstDescriptor);
        for (AMSearchDescriptor *arg = firstDescriptor; arg != nil; arg = va_arg(args, AMSearchDescriptor*)) {
            [subDescriptors addObject:arg];
        }
        va_end(args);
    }
    return self;
}

- (NSArray*) searchDescriptors {
    return subDescriptors;
}

- (void) setSearchDescriptors:(NSArray*)descriptors {
    [subDescriptors removeAllObjects];
    [subDescriptors addObjectsFromArray:descriptors];
}

- (BOOL) includesCelestialObject:(AMCelestialObject*)object {
    for(AMSearchDescriptor *descriptor in subDescriptors){
        BOOL inclsub = [descriptor includesCelestialObject:object];
        if([self searchOperator]==AMAndSearchOperator && !inclsub){
            return NO;
        }
        if([self searchOperator]==AMAndSearchOperator && inclsub){
            return YES;
        }
    }
    if([self searchOperator]==AMAndSearchOperator) return YES;
    return NO;
}

@end
