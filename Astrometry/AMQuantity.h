//
//  AMQuantity.h
//  Astrometry
//
//  Created by Don Willems on 23/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMQuantity : NSObject

+ (AMQuantity*) quantityWithName:(NSString*)name;

- (id) initWithName:(NSString*)name andSymbol:(NSString*)symbol;

@property (readonly) NSString *name;
@property (readonly) NSString *symbol;

@end
