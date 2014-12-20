//
//  AMCatalogueSelectionSheetController.h
//  Astrometry
//
//  Created by Don Willems on 14/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMCatalogueReader,AMCatalogueSelectionDatasource,AMCatalogue;

@interface AMCatalogueSelectionSheetController : NSObject {
    IBOutlet NSWindow *sheetWindow;
    IBOutlet NSButton *okButton;
    IBOutlet NSButton *previousButton;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSButton *layerCheckBox;
    
    IBOutlet NSView *catalogueSelectionView;
    IBOutlet NSView *catalogueRestrictionsView;
    IBOutlet NSView *catalogueContentView;
    IBOutlet NSView *placeholderView;
    
    NSInteger mode;
    AMCatalogueReader *catReader;
    NSMutableArray *catalogues;
    AMCatalogueSelectionDatasource *catalogueSelectionDatasource;
    
    IBOutlet NSTableView *catalogueList;
}

- (AMCatalogue*) selectedCatalogue;

- (NSWindow*) sheetWindow;
- (NSModalResponse) returnCodeWhenClickedOnButton:(id)sender;

- (IBAction) previousViewRequested:(id)sender;
- (IBAction) nextViewRequested:(id)sender;
- (IBAction) closeCatalogueSelectionSheet:(id)sender;

@end
