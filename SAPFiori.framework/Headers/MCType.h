/*
 *  MCType.h
 *
 *  Created by Daniel Cascais on 3/10/11.
 *  Copyright 2011 MeLLmo. All rights reserved.
 *
 */

#pragma once

typedef enum MCType
{
    MC_TYPE_UNDEFINED,
	MC_TYPE_LINE,
//    MC_TYPE_LINE_STACKED,
//    MC_TYPE_LINE_ONE_HUNDRED_PERCENT_STACKED,
//    MC_TYPE_LINE_STEP,
	MC_TYPE_AREA,
    MC_TYPE_TRENDS_VIEW,
//    MC_TYPE_AREA_STACKED,
//    MC_TYPE_AREA_ONE_HUNDRED_PERCENT_STACKED,
//    MC_TYPE_AREA_STEP,
	MC_TYPE_COLUMN_CLUSTERED,
    MC_TYPE_COLUMN_STACKED,
//    MC_TYPE_COLUMN_ONE_HUNDRED_PERCENT_STACKED,
    //MC_TYPE_BAR_CLUSTERED,
    //MC_TYPE_BAR_STACKED,
    //MC_TYPE_BAR_ONE_HUNDRED_PERCENT_STACKED,
    MC_TYPE_BAR_STACKED_SINGLE,
    MC_TYPE_BAR_COMPARE,
    MC_TYPE_STACKED_BAR_VS_TARGET_VALUE,
    MC_TYPE_BAR_DATA_VALUE,
    MC_TYPE_SCATTER,
    //MC_TYPE_PLOT,
    MC_TYPE_BUBBLE,
    //MC_TYPE_SURFACE,
	MC_TYPE_PARETO, // Column-Line chart
    
    //
    // POLAR CHARTS
    //
    MC_TYPE_PIE,
    //MC_TYPE_POLAR_PLOT,
    //MC_TYPE_DONUT,
    //MC_TYPE_RADAR
    MC_TYPE_WATERFALL
    
	// etc...
} MCType;
