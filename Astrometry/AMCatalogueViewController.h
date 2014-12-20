//
//  AMCatalogueViewController.h
//  Astrometry
//
//  Created by Don Willems on 18/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMCatalogue;

@interface AMCatalogueViewController : NSViewController {
    IBOutlet NSImageView *iconV;
    IBOutlet NSTextField *nameTF;
    IBOutlet NSTextField *descriptionTF;
}

- (id) initWithCatalogue:(AMCatalogue*)catalogue;

@property (readwrite,strong) AMCatalogue* catalogue;

@end
