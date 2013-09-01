//
//  COCCacheDemoObjCPP.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCCacheDemoObjCPP.h"
#import <unordered_map>

struct CacheKey
{
    double      numberValue;
    NSString*   stringValue;

    bool operator==(const CacheKey& key) const{
        return numberValue == key.numberValue && [stringValue isEqualToString:key.stringValue];
    }
};

namespace std {
    template<>
    struct hash<CacheKey>
    {
        size_t operator()(const CacheKey& key) const
        {
            size_t hash = 17;
            hash        = 37 * hash + key.numberValue;
            hash        = 37 * hash + key.stringValue.hash;
            return hash;
        }
    };
}

@implementation COCCacheDemoObjCPP
{
    std::unordered_map<CacheKey, id> _cache;
}

- (id)cachedObjectForNumberValue:(double)numberValue
                     stringValue:(NSString*)stringValue
                   creationBlock:(id (^)(double numberValue, NSString* stringValue))creationBlock
{
    NSParameterAssert(stringValue);

    CacheKey key = { numberValue, stringValue };
    if(creationBlock)
    {
        __strong id& object = _cache[key];
        if(!object && creationBlock)
        {
            object = creationBlock(numberValue, stringValue);
            NSAssert(object, nil);
        }
        return object;
    }
    else
    {
        auto objectIterator = _cache.find(key);
        if(objectIterator == _cache.end())
            return nil;
        else
            return (*objectIterator).second;
    }
}

- (void)removeAllObjects
{
    _cache.clear();
}

@end