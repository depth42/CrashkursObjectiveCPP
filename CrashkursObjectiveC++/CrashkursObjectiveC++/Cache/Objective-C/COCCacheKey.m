//
//  COCCacheKey.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCCacheKey.h"

@implementation COCCacheKey

- (id)initWithNumberValue:(double)numberValue
              stringValue:(NSString*)stringValue
{
    NSParameterAssert(stringValue);

    if(self = [super init])
    {
        _numberValue = numberValue;
        _stringValue = [stringValue copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:COCCacheKey.class])
        return NO;

    COCCacheKey* key = object;
    return (key.numberValue == _numberValue) && [key.stringValue isEqualToString:_stringValue];
}

- (NSUInteger)hash
{
    NSUInteger hash =  17;
    hash = 37 * hash + _numberValue;
    hash = 37 * hash + _stringValue.hash;
    return hash;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end