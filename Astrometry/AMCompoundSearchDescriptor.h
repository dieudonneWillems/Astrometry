//
//  AMCompoundSearchDescriptor.h
//  Astrometry
//
//  Created by Don Willems on 24/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSearchDescriptor.h"

typedef enum {
    AMAndSearchOperator,
    AMOrSearchOperator
} AMCompoundSearchOperator;

@interface AMCompoundSearchDescriptor : AMSearchDescriptor {
    NSMutableArray *subDescriptors;
}

- (id) initWithOperator:(AMCompoundSearchOperator)searchOperator;
- (id) initWithOperator:(AMCompoundSearchOperator)searchOperator searchDescriptors:(AMSearchDescriptor*)firstDescriptor,...
NS_REQUIRES_NIL_TERMINATION;

@property (readonly) AMCompoundSearchOperator searchOperator;

- (NSArray*) searchDescriptors;
- (void) setSearchDescriptors:(NSArray*)descriptors;

@end
