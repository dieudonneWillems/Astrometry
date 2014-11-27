//
//  AMCoordinateRulesLayer.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMLayer.h"

@interface AMCoordinateRulesLayer : AMLayer {
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *descriptionField;
    IBOutlet NSButton *visibilityCB;
}

@end
