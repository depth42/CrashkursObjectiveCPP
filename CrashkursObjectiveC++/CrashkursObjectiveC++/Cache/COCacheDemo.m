//
//  COCacheDemo.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCacheDemo.h"

static NSUInteger const cacheSize = 500000;
static NSUInteger const numberOfStrings = 100;
static NSUInteger const numberOfLookups = 2;

@implementation COCacheDemo
{
    NSMutableArray* _strings;
}

- (id)init
{
    if(self = [super init])
    {
        [self createStrings];
    }
    return self;
}

- (void)run
{
    self.creationTime = [self executionTimeOfBlock:^{
        [self createCache];
    }];

    self.lookupTime = [self executionTimeOfBlock:^{
        [self lookupValues];
    }];
}

- (void)createStrings
{
    _strings = [NSMutableArray array];
    NSUInteger numberOfStrings = 10;
    for(NSUInteger index=0; index<numberOfStrings; index++)
    {
        NSUUID* UUID = [NSUUID UUID];
        [_strings addObject: [UUID.UUIDString copy]];
    }
}

- (void)createCache
{
    [self removeAllObjects];

    NSNumber* cachedObject = @42;
    NSUInteger innerCount = cacheSize / _strings.count;
    for(NSString* iString in _strings)
        for(NSUInteger innerIndex=0; innerIndex<innerCount; innerIndex++)
            [self cachedObjectForNumberValue:0.5 * (double)innerIndex
                                 stringValue:iString
                               creationBlock:^id(double numberValue, NSString* stringValue) {
                                   return cachedObject;
                               }];
}

- (void)lookupValues
{
    NSUInteger innerCount = cacheSize / _strings.count;
    NSUInteger count = numberOfLookups;
    for(NSUInteger index=0; index<count; index++)
    {
         for(NSString* iString in _strings)
         {
             for(NSUInteger innerIndex=0; innerIndex<innerCount; innerIndex++)
             {
                 __unused id object = [self cachedObjectForNumberValue:0.5 * (double)innerIndex
                                                           stringValue:iString
                                                         creationBlock:nil];
                 NSAssert(object, nil);
             }
         }
    }
}
@end