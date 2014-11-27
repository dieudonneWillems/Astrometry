//
//  AMMapGridLayer.h
//  Astrometry
//
//  Created by Don Willems on 27/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMLayer.h"

@interface AMMapGridLayer : AMLayer{
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *descriptionField;
}

@property (readwrite) NSColor *majorGridLineColor;
@property (readwrite) NSColor *minorGridLineColor;

- (IBAction) changeMajorGridLineColor:(id)sender;
- (IBAction) changeMinorGridLineColor:(id)sender;

@end
