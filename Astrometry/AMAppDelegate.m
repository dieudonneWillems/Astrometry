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

@interface AMAppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    AMUnit *m = AMCreateSingularBaseUnit(@"metre", @"m");
    AMQuantity *L = malloc(sizeof(AMQuantity));
    AMCreateQuantity(L, @"length", @"L");
    AMMeasure *measure = malloc(sizeof(AMMeasure));
    AMCreateMeasureWithError(measure, L, 12.02337,0.012, m);
    NSLog(@"Length: %@",NSStringFromMeasure(*measure));
    AMFreeUnit(m);
    AMFreeQuantity(L);
    AMFreeMeasure(measure);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
