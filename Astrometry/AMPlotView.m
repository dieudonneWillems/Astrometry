//
//  AMPlotView.m
//  Astrometry
//
//  Created by Don Willems on 25/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMPlotView.h"
#import "AMPlot.h"
#import "AMLayer.h"

@interface AMPlotView (private)
- (void) layerVisibilityChangedNotificationRecieved:(NSNotification*)notification;
@end

@implementation AMPlotView

- (id) init {
    self = [super init];
    if(self){
    }
    return self;
}

- (id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(self){
    }
    return self;
}

- (void) awakeFromNib {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(layerVisibilityChangedNotificationRecieved:) name:AMLayerChangedVisibilityNotification object:nil];
}

- (void) layerVisibilityChangedNotificationRecieved:(NSNotification*)notification {
    NSLog(@"Received layer changed visibility notification");
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"frame : %@",NSStringFromRect([self frame]));
    [super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    NSRect frame = [self frame];
    frame.origin.x =40;
    frame.origin.y =80;
    frame.size.width -=80;
    frame.size.height -=120;
    [[self plot] setViewRect:frame];
    NSLog(@"viewrect : %@",NSStringFromRect(frame));
    NSArray *layers = [[self plot] layers];
    for(AMLayer *layer in layers){
        if([layer visible]){
            [layer drawRect:dirtyRect onPlot:[self plot] inView:self];
        }
    }
}

@end
