//
//  COCCacheDemoObjC.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCCacheDemoObjC.h"
#import "COCCacheKey.h"

@implementation COCCacheDemoObjC
{
    NSMutableDictionary*  _cache;       // COCCacheKey -> id
}

- (id)init
{
    if(self = [super init])
    {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)cachedObjectForNumberValue:(double)numberValue
                     stringValue:(NSString*)stringValue
                   creationBlock:(id (^)(double numberValue, NSString* stringValue))creationBlock
{
    NSParameterAssert(stringValue);

    NSAssert(_cache, nil);

    COCCacheKey* key = [[COCCacheKey alloc] initWithNumberValue:numberValue
                                                    stringValue:stringValue];
    id object = _cache[key];
    if(!object && creationBlock)
    {
        object = creationBlock(numberValue, stringValue);
        NSAssert(object, nil);
        _cache[key] = object;
    }
    return object;
}

- (void)removeAllObjects
{
    [_cache removeAllObjects];
}
@end