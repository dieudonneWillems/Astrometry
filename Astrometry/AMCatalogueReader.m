//
//  AMCatalogueReader.m
//  Astrometry
//
//  Created by Don Willems on 22/11/14.
//  Copyright (c) 2014 lapsedpacifist. All rights reserved.
//

#import "AMCatalogueReader.h"
#import "AMCatalogue.h"
#import "AMTypes.h"
#import "AMFunctions.h"
#import "AMPropertyKeyStack.h"
#import "AMUnitAndQuantityStack.h"

@interface AMCatalogueReader (private)
+ (void) readObjectsFromFile:(NSString*)file usingXMLDefinition:(NSArray*)elements intoCatalogue:(AMCatalogue*)catalogue error:(NSError**)error;
+ (AMCelestialObject*) readObjectFromLine:(NSString*)line usingXMLDefinition:(NSArray*)elements error:(NSError**)error;
+ (NSString*) dataFromLine:(NSString*)line startingAt:(NSUInteger)start endingAt:(NSUInteger)end;
+ (NSString*) stringValueOffield:(NSXMLElement*)fieldElement fromLine:(NSString*)line ;
+ (AMMeasure*) measureFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line;
+ (NSString*) stringValueOfElement:(NSXMLElement*)element fromLine:(NSString*)line;
@end

@implementation AMCatalogueReader

+ (AMCatalogue*) readCatalogueFromXMLFile:(NSString*)catalogueFile error:(NSError**)error {
    AMCatalogue *catalogue = [[AMCatalogue alloc] init];
    catalogueFile = [catalogueFile stringByExpandingTildeInPath];
    NSString *xmlString = [NSString stringWithContentsOfFile:catalogueFile encoding:NSUTF8StringEncoding error:error];
    if(*error) return nil;
    NSXMLDocument* xmlDoc;
    NSUInteger options = NSXMLNodePreserveWhitespace|NSXMLDocumentTidyXML;
    xmlDoc = [[NSXMLDocument alloc] initWithXMLString:xmlString
                                              options:options
                                                error:error];
    if(*error) return nil;
    NSXMLElement *root = [xmlDoc rootElement];
    NSArray *children = [root children];
    for(NSXMLNode *child in children){
        if([[child name] isEqualToString:@"name"]) [catalogue setName:[child stringValue]];
        if([[child name] isEqualToString:@"description"]) [catalogue setCatalogueDescription:[child stringValue]];
        if([[child name] isEqualToString:@"file"]){
            NSString *cfile = [[(NSXMLElement*)child attributeForName:@"src"] stringValue];
            cfile = [cfile stringByExpandingTildeInPath];
            NSArray *linees = [child nodesForXPath:@"line" error:error];
            NSXMLElement *linee = nil;
            if([linees count]>0){
                linee = [linees objectAtIndex:0];
                [AMCatalogueReader readObjectsFromFile:cfile usingXMLDefinition:[linee children] intoCatalogue:catalogue error:error];
                if(*error) return nil;
            }
        }
    }
    return catalogue;
}

+ (void) readObjectsFromFile:(NSString*)file usingXMLDefinition:(NSArray*)elements intoCatalogue:(AMCatalogue*)catalogue error:(NSError**)error{
    NSString *catfile = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:error];
    if(*error) return;
    NSArray *lines = [catfile componentsSeparatedByString:@"\n"];
    for(NSString *line in lines){
        NSString *tline = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSError *objectError = nil;
        if([tline length]>0){
            AMCelestialObject* celestialobject = [self readObjectFromLine:line usingXMLDefinition:elements error:&objectError];
        }
        if(objectError){
            NSLog(@"Could not read object from line:\n%@\nerror:%@",line,objectError);
        }
    }
}

+ (AMCelestialObject*) readObjectFromLine:(NSString*)line usingXMLDefinition:(NSArray*)elements error:(NSError**)error {
    AMCelestialObject *object = AMCreateCelestialObject();
    for(NSXMLElement *element in elements){
        if([[element name] isEqualToString:@"parameter"]){
            NSString *key = nil;
            NSString *value = nil;
            for(NSXMLNode *node in [element children]){
                if([[node name] isEqualToString:@"key"]){
                    key = [node stringValue];
                }
                if([[node name] isEqualToString:@"value"]){
                    value = [self stringValueOfElement:(NSXMLElement*)node fromLine:line];
                }
            }
            if(value){
                AMPropertyKey *pkey = [[AMPropertyKeyStack sharedPropertyKeyStack] propertyWihtKeyName:key];
                AMAddPropertyToCelectialObject(object, pkey, value);
            }
        }else if([[element name] isEqualToString:@"measure"]){
            AMMeasure *measure = [self measureFromField:element fromLine:line];
            AMAddMeasureToCelestialObject(object, measure);
        }
    }
    NSLog(@"Read %@",NSStringFromCelestialObject(*object));
    return object;
}

+ (AMMeasure*) measureFromField:(NSXMLElement*)fieldElement fromLine:(NSString*)line {
    AMQuantity *quantity = NULL;
    double value = 0;
    double positiveError = 0;
    double negativeError = 0;
    AMUnit *unit = NULL;
    NSArray *children = [fieldElement children];
    for(NSXMLNode *child in children){
        if([child isKindOfClass:[NSXMLElement class]]){
            if([[child name] isEqualToString:@"quantity"]){
                NSString *qname = [self stringValueOfElement:(NSXMLElement*)child fromLine:line];
                AMUnitAndQuantityStack *stack = [AMUnitAndQuantityStack sharedUnitAndQuantityStack];
                quantity = [stack quantityWithName:qname];
            }else if([[child name] isEqualToString:@"value"]){
                value = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"error"]){
                double error = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
                positiveError = error;
                negativeError = error;
            }else if([[child name] isEqualToString:@"positive-error"]){
                positiveError = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"negative-error"]){
                negativeError = [[self stringValueOfElement:(NSXMLElement*)child fromLine:line] doubleValue];
            }else if([[child name] isEqualToString:@"unit"]){
                NSString *uname = [self stringValueOfElement:(NSXMLElement*)child fromLine:line];
                unit = [[AMUnitAndQuantityStack sharedUnitAndQuantityStack] unitWithName:uname];
            }
        }
    }
    AMMeasure *measure = AMCreateMeasureWithPositiveAndNegativeError(quantity, value, positiveError, negativeError, unit);
    return measure;
}

+ (NSString*) stringValueOfElement:(NSXMLElement*)element fromLine:(NSString*)line {
    NSMutableString *value = nil;
    NSArray *children = [element children];
    for(NSXMLNode *cn in children){
        if([cn isKindOfClass:[NSXMLElement class]]){
            if([[cn name] isEqualToString:@"field"]){
                NSString *field = [AMCatalogueReader stringValueOffield:(NSXMLElement*)cn fromLine:line];
                if(field) {
                    if(!value) value = [NSMutableString string];
                    [value appendString:field];
                }
            }else{
                if(!value) value = [NSMutableString string];
                [value appendString:[cn stringValue]];
            }
        }else{
            if(!value) value = [NSMutableString string];
            [value appendString:[cn stringValue]];
        }
    }
    return value;
}

+ (NSString*) stringValueOffield:(NSXMLElement*)fieldElement fromLine:(NSString*)line {
    NSUInteger start = [[[fieldElement attributeForName:@"start"] stringValue] integerValue];
    NSUInteger end = [[[fieldElement attributeForName:@"end"] stringValue] integerValue];
    NSString *string = [AMCatalogueReader dataFromLine:line startingAt:start endingAt:end];
    NSString *trim = [[fieldElement attributeForName:@"trim"] stringValue];
    if([trim isEqualToString:@"yes"] || [trim isEqualToString:@"true"]) string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string;
}

+ (NSString*) dataFromLine:(NSString*)line startingAt:(NSUInteger)start endingAt:(NSUInteger)end {
    if([line length]<end) return nil;
    return [line substringWithRange:NSMakeRange(start-1, end-start+1)];
}

@end
