//
//  MCSelectionStrategy.h
//  ChartKit
//
//  Created by Daniel Cascais on 7/19/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MCEvents.h"
#import "MCSelectedState.h"
#import "MCSelection.h"

#define MAX_TOUCH_COUNT (2)


/**
 // TODO: Update documentation.
 A selection strategy's role is to translate coordinates of user touch/slider positions to a set of one or more selections.
 
 The UIKit layer will determine when / how many / and the manner in which touches are received.
 
 MCChartLayer is responsible for determining what adornments, if any, will be displayed.
 
 Roambi currently employs several different types of strategies.
 - Single user selection.
 - Dual user selection.
 - Single user selection + fixed.
 - Single user selection + dynamic (vs previous).
 
 Other charting implementations support others that we might implement someday.
 - A selection in every series for a given value index (Google Charts).
 - The ability to select bubbles in a bubble chart by tapping on them.
 
 The default implementation transforms a single touch location into a single MCSelection object and supports up to two touches (start/end).
 
 The simplest way to create a custom strategy is to subclass MCSelectionStrategy.
 Override makeSelectionsForPosition: to provide any number of selections in addition to the MCSelection returned by the base class.
 Override updateSelections:withPosition: to update the properties of each custom selection.
 */
@interface MCSelectionStrategy : NSObject
{
@protected
    MCContextRef _context;
    __weak CALayer* _superLayer;
    NSMutableArray* _adornments;
    NSMutableArray* _selections;
}

- (id)initWithChartContext:(MCContextRef)chartContext andSuperLayer:(CALayer*)superLayer;

/**
 */
- (void)updateWithSelectedState:(const MCSelectedState*)selectedState;
- (NSArray*)makeSelectionsWithSelectedState:(const MCSelectedState*)selectedState;

#pragma mark Subclassing



#pragma mark Convenience / Subclass Helpers

- (MCContextRef)context;

/**
 Number of series currently displayed by the chart.
 */
@property (nonatomic, readonly) NSUInteger seriesCount;

/**
 Clears the selectionInfo struct and sets the valueIndex, seriesIndex, touchPosition, valuePosition and value properties.
 */

- (MCSelectionValueInfo)getSelectionInfo:(int)series index:(int)index touchIndex:(int)touchIndex;

/**
 Returns all current selections.
 */
- (NSArray<MCSelection*>*)selections;
@end
