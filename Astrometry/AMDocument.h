//
//  Document.h
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMCatalogue,AMLayer,AMPlotView,AMPlot,AMListDatasource,AMListView,AMCatalogueSelectionSheetController;

@interface AMDocument : NSDocument {
    NSMutableArray *catalogues;
    NSMutableArray *plots;
    AMPlot *selectedPlot;
    IBOutlet AMPlotView *plotview;
    IBOutlet AMListView *itemList;
    IBOutlet NSWindow *documentWindow;
    AMCatalogueSelectionSheetController *catalogueSelectionSheet;
}

#pragma mark Actions

- (IBAction) showCatalogueSelectionSheet:(id)sender;

#pragma mark Catalogues part of the document

- (NSArray*) catalogues;
- (void) addCatalogueWithName:(NSString*)name;
- (void) addCatalogue:(AMCatalogue*)catalogue;

#pragma mark Plots

- (void) addPlot:(AMPlot*)plot;
- (void) removePlot:(AMPlot*)plot;
- (NSArray*) plots;
- (AMPlot*) selectedPlot;
- (void) setSelectedPlot:(AMPlot *)plot;

@end

