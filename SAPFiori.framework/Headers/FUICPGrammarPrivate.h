//
//  FUICPGrammarPrivate.h
//  CoreParse
//
//  Created by Tom Davie on 04/06/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUICPGrammar.h"

@interface FUICPGrammar (FUICPGrammarPrivate)

@property (readwrite,copy  ) NSArray *rules;

@property (readwrite,retain) NSMutableDictionary *rulesByNonTerminal;
@property (readwrite,retain) NSMutableDictionary *followCache;

- (NSArray *)orderedRules;

- (NSSet *)allSymbolNames;
- (NSSet *)symbolNamesInRules:(NSArray *)rules;
- (NSSet *)firstSymbol:(FUICPGrammarSymbol *)obj;

@end
