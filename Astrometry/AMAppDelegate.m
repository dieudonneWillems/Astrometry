//
//  AppDelegate.m
//  Astrometry
//
//  Created by Don Willems on 20/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMTypes.h"
#import "AMFunctions.h"
#import "AMCatalogue.h"
#import "AMCatalogueReader.h"
#import "AMUnitAndQuantityStack.h"

@interface AMAppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    AMUnit *m = AMCreateSingularBaseUnit(@"metre", @"m");
    AMQuantity *L = AMCreateQuantity(@"length", @"L");
    AMMeasure *measure = AMCreateMeasureWithError(L, 12.02337,0.012, m);
    NSLog(@"Length: %@",NSStringFromMeasure(*measure));
    AMFreeUnit(m);
    AMFreeQuantity(L);
    AMFreeMeasure(measure);
    NSError *error = nil;
    [AMUnitAndQuantityStack sharedUnitAndQuantityStack];
    AMCatalogue *catalogue = [AMCatalogueReader readCatalogueFromXMLFile:@"~/Development/Astrometry/Astrometry/OMCenFORS.xml" error:&error];
    if(error){
        NSLog(@"Could not read catalogue file: %@",error);
    }else{
        NSLog(@"Read catalogue\n%@",catalogue);
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
