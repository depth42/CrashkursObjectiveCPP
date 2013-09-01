//
//  COCCacheKey.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

@interface COCCacheKey : NSObject <NSCopying>

- (id)initWithNumberValue:(double)numberValue
              stringValue:(NSString*)stringValue;

@property (nonatomic, readonly)             double      numberValue;
@property (nonatomic, readonly, copy)       NSString*   stringValue;

@end
