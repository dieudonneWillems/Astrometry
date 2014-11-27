//
//  AppDelegate.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMAppDelegate.h"

#import "AMAppDelegate.h"
#import "AMTypes.h"
#import "AMUnit.h"
#import "AMQuantity.h"
#import "AMScalarMeasure.h"
#import "AMCatalogue.h"
#import "AMCatalogueReader.h"
#import "AMScalarQuantitySearchDescriptor.h"
#import "AMCompoundSearchDescriptor.h"
#import "AMColourIndexCalculator.h"

@interface AMAppDelegate ()

@end

@implementation AMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /*
    NSError *error = nil;
    AMCatalogueReader *reader = [[AMCatalogueReader alloc] init];
    [reader addCalculator:[[AMColourIndexCalculator alloc] initWithColourIndex:[AMQuantity quantityWithName:@"Colour index B-R"] magnitudeQuantities:[AMQuantity quantityWithName:@"B magnitude"] and:[AMQuantity quantityWithName:@"R magnitude"]]];
    AMCatalogue *catalogue = [reader readCatalogueFromXMLFile:@"~/Development/Astrometry/Astrometry/OMCenFORS.xml" error:&error];
    
    if(error){
        NSLog(@"Could not read catalogue file: %@",error);
    }else{
        NSLog(@"Read catalogue\n%@",catalogue);
     
        AMCompoundSearchDescriptor *csd = [[AMCompoundSearchDescriptor alloc] initWithOperator:AMAndSearchOperator searchDescriptors:
                                           [[AMScalarQuantitySearchDescriptor alloc] initForQuantity:[AMQuantity quantityWithName:@"Right ascension"] maxValue:201.54 minValue:201.52 inUnit:[AMUnit unitWithName:@"degree"]],
                                           [[AMScalarQuantitySearchDescriptor alloc] initForQuantity:[AMQuantity quantityWithName:@"Declination"] maxValue:-47.62 minValue:-47.64 inUnit:[AMUnit unitWithName:@"degree"]], nil];
        AMCatalogue *subset = [catalogue subsetUsingSearchDescriptor:csd];
        NSLog(@"Subset catalogue\n%@",subset);
        NSArray *objects = [subset celestialObjects];
        for(AMCelestialObject *obj in objects){
            NSLog(@"%@",obj);
        }
     
    }
     */
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
