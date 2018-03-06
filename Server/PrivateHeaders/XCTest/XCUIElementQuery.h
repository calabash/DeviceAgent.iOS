// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCTElementSnapshotProvider-Protocol.h"
#import "XCUIElementTypeQueryProvider-Protocol.h"

@class NSArray, NSOrderedSet, NSString, XCElementSnapshot, XCTElementQuery, XCUIApplication, XCUIElement;


@protocol XCTElementSetTransformer;

@interface XCUIElementQuery : NSObject <XCTElementSnapshotProvider, XCUIElementTypeQueryProvider>
{
    BOOL _changesScope;
    BOOL _stopsOnFirstMatch;
    XCUIElementQuery *_inputQuery;
    NSUInteger _expressedType;
    NSArray *_expressedIdentifiers;
    NSOrderedSet *_lastInput;
    NSOrderedSet *_lastOutput;
    XCElementSnapshot *_rootElementSnapshot;
    NSString *_queryDescription;
    id <XCTElementSetTransformer> _transformer;
}

@property(readonly, copy) XCUIElementQuery *activityIndicators;
@property(readonly, copy) XCUIElementQuery *alerts;
@property(readonly, copy) NSArray *allElementsBoundByAccessibilityElement;
@property(readonly, copy) NSArray *allElementsBoundByIndex;
@property(readonly) XCUIApplication *application;
@property(readonly, copy) XCTElementQuery *backingQuery;
@property(readonly, copy) XCUIElementQuery *browsers;
@property(readonly, copy) XCUIElementQuery *buttons;
@property(readonly, copy) XCUIElementQuery *cells;
@property BOOL changesScope;
@property(readonly, copy) XCUIElementQuery *checkBoxes;
@property(readonly, copy) XCUIElementQuery *collectionViews;
@property(readonly, copy) XCUIElementQuery *colorWells;
@property(readonly, copy) XCUIElementQuery *comboBoxes;
@property(readonly) NSUInteger count;
@property(readonly, copy) XCUIElementQuery *datePickers;
@property(readonly, copy) XCUIElementQuery *decrementArrows;
@property(readonly, copy) XCUIElementQuery *dialogs;
@property(readonly, copy) XCUIElementQuery *disclosureTriangles;
@property(readonly, copy) XCUIElementQuery *dockItems;
@property(readonly, copy) XCUIElementQuery *drawers;
@property(readonly) XCUIElement *element;
@property(readonly, copy) NSString *elementDescription;
@property(readonly, copy) XCElementSnapshot *elementSnapshotForDebugDescription;
@property(copy) NSArray *expressedIdentifiers;
@property NSUInteger expressedType;
@property(readonly) XCUIElement *firstMatch;
@property(readonly, copy) XCUIElementQuery *grids;
@property(readonly, copy) XCUIElementQuery *groups;
@property(readonly, copy) XCUIElementQuery *handles;
@property(readonly, copy) XCUIElementQuery *helpTags;
@property(readonly, copy) XCUIElementQuery *icons;
@property(readonly, copy) XCUIElementQuery *images;
@property(readonly, copy) XCUIElementQuery *incrementArrows;
@property(readonly) XCUIElementQuery *inputQuery;
@property(readonly, copy) XCUIElementQuery *keyboards;
@property(readonly, copy) XCUIElementQuery *keys;
@property(copy) NSOrderedSet *lastInput;
@property(copy) NSOrderedSet *lastOutput;
@property(readonly, copy) XCUIElementQuery *layoutAreas;
@property(readonly, copy) XCUIElementQuery *layoutItems;
@property(readonly, copy) XCUIElementQuery *levelIndicators;
@property(readonly, copy) XCUIElementQuery *links;
@property(readonly, copy) XCUIElementQuery *maps;
@property(readonly, copy) XCUIElementQuery *mattes;
@property(readonly, copy) XCUIElementQuery *menuBarItems;
@property(readonly, copy) XCUIElementQuery *menuBars;
@property(readonly, copy) XCUIElementQuery *menuButtons;
@property(readonly, copy) XCUIElementQuery *menuItems;
@property(readonly, copy) XCUIElementQuery *menus;
@property(readonly, copy) XCUIElementQuery *navigationBars;
@property(readonly, copy) XCUIElementQuery *otherElements;
@property(readonly, copy) XCUIElementQuery *outlineRows;
@property(readonly, copy) XCUIElementQuery *outlines;
@property(readonly, copy) XCUIElementQuery *pageIndicators;
@property(readonly, copy) XCUIElementQuery *pickerWheels;
@property(readonly, copy) XCUIElementQuery *pickers;
@property(readonly, copy) XCUIElementQuery *popUpButtons;
@property(readonly, copy) XCUIElementQuery *popovers;
@property(readonly, copy) XCUIElementQuery *progressIndicators;
@property(readonly, copy) NSString *queryDescription;
@property(readonly, copy) XCUIElementQuery *radioButtons;
@property(readonly, copy) XCUIElementQuery *radioGroups;
@property(readonly, copy) XCUIElementQuery *ratingIndicators;
@property(readonly, copy) XCUIElementQuery *relevanceIndicators;
@property(retain) XCElementSnapshot *rootElementSnapshot;
@property(readonly, copy) XCUIElementQuery *rulerMarkers;
@property(readonly, copy) XCUIElementQuery *rulers;
@property(readonly, copy) XCUIElementQuery *scrollBars;
@property(readonly, copy) XCUIElementQuery *scrollViews;
@property(readonly, copy) XCUIElementQuery *searchFields;
@property(readonly, copy) XCUIElementQuery *secureTextFields;
@property(readonly, copy) XCUIElementQuery *segmentedControls;
@property BOOL stopsOnFirstMatch;
@property(retain) id <XCTElementSetTransformer> transformer;
@property(readonly, copy) XCUIElementQuery *sheets;
@property(readonly, copy) XCUIElementQuery *sliders;
@property(readonly, copy) XCUIElementQuery *splitGroups;
@property(readonly, copy) XCUIElementQuery *splitters;
@property(readonly, copy) XCUIElementQuery *staticTexts;
@property(readonly, copy) XCUIElementQuery *statusBars;
@property(readonly, copy) XCUIElementQuery *statusItems;
@property(readonly, copy) XCUIElementQuery *steppers;
@property(readonly, copy) XCUIElementQuery *switches;
@property(readonly, copy) XCUIElementQuery *tabBars;
@property(readonly, copy) XCUIElementQuery *tabGroups;
@property(readonly, copy) XCUIElementQuery *tableColumns;
@property(readonly, copy) XCUIElementQuery *tableRows;
@property(readonly, copy) XCUIElementQuery *tables;
@property(readonly, copy) XCUIElementQuery *tabs;
@property(readonly, copy) XCUIElementQuery *textFields;
@property(readonly, copy) XCUIElementQuery *textViews;
@property(readonly, copy) XCUIElementQuery *timelines;
@property(readonly, copy) XCUIElementQuery *toggles;
@property(readonly, copy) XCUIElementQuery *toolbarButtons;
@property(readonly, copy) XCUIElementQuery *toolbars;
@property(readonly, copy) XCUIElementQuery *touchBars;
@property(readonly, copy) XCUIElementQuery *valueIndicators;
@property(readonly, copy) XCUIElementQuery *webViews;
@property(readonly, copy) XCUIElementQuery *windows;

- (id)_containingPredicate:(id)arg1 queryDescription:(id)arg2;
- (id)_debugDescriptionWithIndent:(id *)arg1 rootElementSnapshot:(id)arg2;
- (id)_derivedExpressedIdentifiers;
- (NSUInteger)_derivedExpressedType;
- (id)_descendantMatchingAccessibilityElement:(id)arg1;
- (id)_elementMatchingAccessibilityElementOfSnapshot:(id)arg1;
- (id)_predicateWithType:(NSUInteger)arg1 identifier:(id)arg2;
- (id)_queryWithPredicate:(id)arg1;
- (id)_queryWithPredicate:(id)arg1 description:(id)arg2;
- (BOOL)_resolveRemoteElements:(id)arg1 inSnapshot:(id)arg2 error:(id *)arg3;
- (id)ascending:(NSUInteger)arg1;
- (id)childrenMatchingType:(NSUInteger)arg1;
- (id)containingPredicate:(id)arg1;
- (id)containingType:(NSUInteger)arg1 identifier:(id)arg2;
- (id)debugDescriptionWithSnapshot:(id)arg1;
- (id)descendantsMatchingType:(NSUInteger)arg1;
- (id)descending:(NSUInteger)arg1;
- (id)elementAtIndex:(NSUInteger)arg1;
- (id)elementBoundByIndex:(NSUInteger)arg1;
- (id)elementMatchingPredicate:(id)arg1;
- (id)elementMatchingType:(NSUInteger)arg1 identifier:(id)arg2;
- (id)elementWithIdentifier:(id)arg1;
- (id)elementWithLabel:(id)arg1;
- (id)elementWithPlaceholderValue:(id)arg1;
- (id)elementWithTitle:(id)arg1;
- (id)elementWithValue:(id)arg1;
- (id)filter:(CDUnknownBlockType)arg1;
- (id)initWithInputQuery:(id)arg1 queryDescription:(id)arg2 transformer:(id)arg3;
- (id)matchingIdentifier:(id)arg1;
- (id)matchingPredicate:(id)arg1;
- (id)matchingSnapshotsForLocallyEvaluatedQuery:(id)arg1 error:(id *)arg2;
- (id)matchingSnapshotsHandleUIInterruption:(BOOL)arg1 withError:(id *)arg2;
- (id)matchingSnapshotsWithError:(id *)arg1;
- (id)matchingType:(NSUInteger)arg1 identifier:(id)arg2;
- (id)objectForKeyedSubscript:(id)arg1;
- (id)snapshotForElement:(id)arg1 attributes:(id)arg2 parameters:(id)arg3 error:(id *)arg4;
- (id)sorted:(CDUnknownBlockType)arg1;


@end
