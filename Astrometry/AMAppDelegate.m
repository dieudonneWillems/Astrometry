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
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
