//
//  MCSelectionStrategy+Internal.h
//  ChartKit
//
//  Created by Brett Callaghan on 8/21/12.
//
//

#import "MCSelectionStrategy.h"
#import "MCContext.h"

@protocol MCSelectionStrategyDelegate;


#pragma mark -
@interface MCSelectionStrategy ()

/**
 Assigned internaly by MCChartLayer when the selectionStrategy property is set.
 The base class uses the context to translate coordinates into selected values.
 */
@property (nonatomic, assign) MCContextRef _Nonnull context;

/**
 Assigned internaly by MCChartLayer when the selectionStrategy property is set.
 The chart layer is the delegate.
 */
@property (nonatomic, weak) id <MCSelectionStrategyDelegate> _Nullable delegate;

@end



#pragma mark -
@protocol MCSelectionStrategyDelegate <NSObject>

/**
 @param selections  Selections that the strategy created.
 */
- (void)selectionStrategy:(nonnull MCSelectionStrategy *)selectionStrategy selectionsBegan:(nullable NSArray<MCSelection*>*)selections;

/**
 @param selections  Selections that have been updated by the selection strategy.
 */
- (void)selectionStrategy:(nonnull MCSelectionStrategy *)selectionStrategy selectionsChanged:(nullable NSArray<MCSelection*>*)selections;

/**
 @param selections  Selections that have ended by the selection strategy.
 */
- (void)selectionStrategy:(nonnull MCSelectionStrategy *)selectionStrategy selectionsEnded:(nullable NSArray<MCSelection*>*)selections;
@end
