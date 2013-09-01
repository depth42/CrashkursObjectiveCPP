//
//  COCSensorDemo.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCSensorDemo.h"

@implementation COCSensorDemo

- (id)init
{
    if(self = [super init])
    {
        _defaultTime = [NSDate date].timeIntervalSinceReferenceDate;
    }
    return self;
}

#pragma mark - Configuration

- (NSUInteger)batchSize
{
    return 10000;
}

- (NSUInteger)numberOfBatches
{
    return 100;
}

- (NSUInteger)numberOfLookups
{
    return 100000;
}

#pragma mark - Performing

- (void)run
{
    self.creationTime = [self executionTimeOfBlock:^{
        [self createReadings];
    }];

    self.lookupTime = [self executionTimeOfBlock:^{
        [self lookupValues];
    }];
}

- (void)createReadings
{
    [self removeAllReadings];
    NSUInteger count = self.numberOfBatches / 2;
    for(NSUInteger index=0; index<count; index++)
    {
        [self appendBatchOfSensorReadings];
        [self prependBatchOfSensorReadings];
    }
}

- (void)lookupValues
{
    NSTimeInterval earliest = self.earliestTime;
    NSTimeInterval latest   = self.latestTime;
    NSTimeInterval duration = latest - earliest;

    NSUInteger count = self.numberOfLookups;
    for(NSUInteger index=0; index<count; index++)
    {
        NSTimeInterval sampleTime = earliest + (arc4random() % (NSInteger)duration);
        [self interpolatedValueAtTime:sampleTime];
    }
}

+ (void)provideRandomValues:(NSInteger)countAndDirection
                  startTime:(NSTimeInterval)startTime
                 usingBlock:(void (^)(NSTimeInterval iTime, double iValue, NSUUID* iSensorID))block
{
    NSParameterAssert(block);

    NSTimeInterval time = startTime;
    NSInteger count = ABS(countAndDirection);
    BOOL backwards = (countAndDirection < 0);

    NSUUID* sensorID = [NSUUID UUID];
    for(int index=0; index<count; index++)
    {
        NSTimeInterval timeDelta = arc4random() % 3600;
        if(backwards)
            time -= timeDelta;
        else
            time += timeDelta;

        double value = arc4random() % 100;
        block(time, value, sensorID);
    }
}

@end