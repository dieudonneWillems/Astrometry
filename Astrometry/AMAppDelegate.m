//
//  AppDelegate.m
//  Astrometry
//
//  Created by Don Willems on 20/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMTypes.h"
#import "AMUnit.h"
#import "AMQuantity.h"
#import "AMScalarMeasure.h"
#import "AMCatalogue.h"
#import "AMCatalogueReader.h"
#import "AMScalarQuantitySearchDescriptor.h"
#import "AMCompoundSearchDescriptor.h"

@interface AMAppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    AMUnit *m = [[AMUnit alloc] initSingularBaseUnitWithName:@"metre" andSymbol:@"m"];
    AMQuantity *L = [[AMQuantity alloc] initWithName:@"length" andSymbol:@"L"];
    AMScalarMeasure *measure = [[AMScalarMeasure alloc] initWithQuantity:L numericalValue:12.023443 positiveError:0.0123 negativeError:0.023 andUnit:m];
    
    NSLog(@"Length: %@",measure);
    
    
    NSError *error = nil;
    AMCatalogue *catalogue = [AMCatalogueReader readCatalogueFromXMLFile:@"~/Development/Astrometry/Astrometry/OMCenFORS.xml" error:&error];
    
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
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
