//
//  AMCatalogueReader.h
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMCatalogue,AMCalculator;

@interface AMCatalogueReader : NSObject {
    NSMutableArray *calculators;
}

- (id) init;

- (void) addCalculator:(AMCalculator*)calculator;
- (void) removeCalculator:(AMCalculator*)calculator;

- (AMCatalogue*) readCatalogueFromXMLFile:(NSString*)catalogueFile error:(NSError**)error;
@end
