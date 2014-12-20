//
//  AMCatalogueCellView.m
//  Astrometry
//
//  Created by Don Willems on 18/12/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueCellView.h"
#import "AMCatalogue.h"

@interface AMCatalogueCellView (private)
- (NSAttributedString*) attributedStringForName;
- (NSAttributedString*) attributedStringForDescription;
@end

@implementation AMCatalogueCellView

- (void) setCatalogue:(AMCatalogue*)cat {
    catalogue = cat;
    icon = [NSImage imageNamed:@"AMCatalogue"];
}

- (NSAttributedString*) attributedStringForName {
    NSBackgroundStyle backgroundStyle = [self backgroundStyle];
    NSColor *textColor = (backgroundStyle == NSBackgroundStyleDark) ? [NSColor whiteColor] : [NSColor textColor];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:12],NSFontAttributeName,textColor,NSForegroundColorAttributeName, nil];
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:[catalogue name] attributes:attr];
    return astr;
}

- (NSAttributedString*) attributedStringForDescription {
    NSBackgroundStyle backgroundStyle = [self backgroundStyle];
    NSColor *textColor = (backgroundStyle == NSBackgroundStyleDark) ? [NSColor whiteColor] : [NSColor textColor];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:10],NSFontAttributeName,textColor,NSForegroundColorAttributeName, nil];
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:[catalogue catalogueDescription] attributes:attr];
    return astr;
}

- (NSSize) preferredSize {
    NSRect frame = [self frame];
    NSSize bsize = NSMakeSize(frame.size.width-30, 0);
    NSAttributedString *name = [self attributedStringForName];
    NSAttributedString *description = [self attributedStringForDescription];
    NSRect nameR = [name boundingRectWithSize:bsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading];
    NSRect descriptionR = [description boundingRectWithSize:bsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading];
    CGFloat height = 4;
    height+=nameR.size.height;
    height+=4;
    height+=descriptionR.size.height;
    height+=4;
    return NSMakeSize(frame.size.width, height);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect frame = [self frame];
    NSSize bsize = NSMakeSize(frame.size.width-30, 0);
    NSAttributedString *name = [self attributedStringForName];
    NSAttributedString *description = [self attributedStringForDescription];
    NSRect nameR = [name boundingRectWithSize:bsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading];
    NSRect descriptionR = [description boundingRectWithSize:bsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading];
    descriptionR.origin.x=30;
    descriptionR.origin.y+=4;
    nameR.origin = descriptionR.origin;
    nameR.origin.y += 4 + descriptionR.size.height;
    [name drawInRect:nameR];
    [description drawInRect:descriptionR];
    NSRect imageRect;
    imageRect.size = NSMakeSize(28, 28);
    imageRect.origin.x = 0;
    imageRect.origin.y = frame.size.height-4-24;
    [icon drawInRect:imageRect];
}

@end
