//
//  COCSensorDemo.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCDemo.h"

@interface COCSensorDemo : COCDemo

// Configuration
@property (nonatomic, readonly)     NSUInteger              batchSize;
@property (nonatomic, readonly)     NSUInteger              numberOfBatches;
@property (nonatomic, readonly)     NSTimeInterval          defaultTime;

+ (void)provideRandomValues:(NSInteger)countAndDirection
                  startTime:(NSTimeInterval)startTime
                 usingBlock:(void (^)(NSTimeInterval iTime, double iValue, NSUUID* iSensorID))block;

// Results
@property (nonatomic, readwrite)    NSTimeInterval          creationTime;
@property (nonatomic, readwrite)    NSTimeInterval          lookupTime;

@end

#pragma mark -

@interface COCSensorDemo (Abstract)

- (void)removeAllReadings;

- (void)appendBatchOfSensorReadings;

- (void)prependBatchOfSensorReadings;

@property (nonatomic, readwrite)    NSTimeInterval          earliestTime;

@property (nonatomic, readwrite)    NSTimeInterval          latestTime;

- (double)interpolatedValueAtTime:(NSTimeInterval)time;

@end