//
//  MCSelectionUpdateKind.h
//  ChartKit
//
//  Created by Daniel Cascais on 7/19/12.
//  Copyright (c) 2012 MeLLmo. All rights reserved.
//

#pragma once

typedef enum : NSUInteger
{
    /*
     Events for individual selections (MCSelection).
     */
    MCEventSelectionBegan             = 1 << 0,
    MCEventSelectionPositionChanged   = 1 << 1,
    MCEventSelectionValueChanged      = 1 << 2,
    MCEventSelectionSeriesChanged     = 1 << 3,
    MCEventSelectionEnded             = 1 << 4,
    
    /*
     Global events.
     */
    MCEventSelectionDataChanged       = 1 << 5,
    MCEventSelectionLayoutChanged     = 1 << 6
} MCEvent;

typedef NSUInteger MCEvents;
