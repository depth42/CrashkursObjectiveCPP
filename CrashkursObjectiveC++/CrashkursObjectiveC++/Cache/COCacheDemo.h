//
//  COCacheDemo.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCDemo.h"

@interface COCacheDemo : COCDemo

// Results
@property (nonatomic, readwrite)    NSTimeInterval          creationTime;
@property (nonatomic, readwrite)    NSTimeInterval          lookupTime;

@end

#pragma mark -

@interface COCacheDemo (Abstract)

- (id)cachedObjectForNumberValue:(double)numberValue
                     stringValue:(NSString*)stringValue
                   creationBlock:(id (^)(double numberValue, NSString* stringValue))creationBlock;

- (void)removeAllObjects;

@end