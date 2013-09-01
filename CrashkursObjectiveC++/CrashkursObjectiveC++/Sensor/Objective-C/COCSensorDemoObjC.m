//
//  COCSensorDemoObjC.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 23.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCSensorDemoObjC.h"
#import "COCSensorReading.h"

@implementation COCSensorDemoObjC
{
    NSMutableArray* _readings; // COCSensorReading
}

- (id)init
{
    if(self = [super init])
    {
        _readings = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllReadings
{
    [_readings removeAllObjects];
}

- (NSTimeInterval)earliestTime
{
    if(_readings.count > 0)
        return ((COCSensorReading*)_readings[0]).time;
    else
        return self.defaultTime;
}

- (NSTimeInterval)latestTime
{
    if(_readings.count > 0)
        return ((COCSensorReading*)_readings.lastObject).time;
    else
        return self.defaultTime;
}

- (void)appendBatchOfSensorReadings
{
    [self.class provideRandomValues:self.batchSize
                          startTime:self.latestTime
                         usingBlock:^(NSTimeInterval iTime,
                                      double iValue,
                                      NSUUID* iSensorID)
     {
         [_readings addObject:
          [[COCSensorReading alloc] initWithTime:iTime
                                           value:iValue
                                        sensorID:iSensorID]];
     }];
}

- (void)prependBatchOfSensorReadings
{
    NSMutableArray* batch = [NSMutableArray arrayWithCapacity:self.batchSize];
    [self.class provideRandomValues:-self.batchSize
                          startTime:self.earliestTime
                         usingBlock:^(NSTimeInterval iTime,
                                      double iValue,
                                      NSUUID* iSensorID)
     {
         [batch addObject:
          [[COCSensorReading alloc] initWithTime:iTime
                                           value:iValue
                                        sensorID:iSensorID]];
     }];

    NSMutableArray* newReadings = [NSMutableArray arrayWithCapacity:
                                   self.batchSize + _readings.count];
    [batch enumerateObjectsWithOptions:NSEnumerationReverse
                            usingBlock:^(COCSensorReading* iReading,
                                         NSUInteger idx,
                                         BOOL* stop)
     {
         [newReadings addObject:iReading];
     }];
    [newReadings addObjectsFromArray:_readings];
    _readings = newReadings;
}

- (double)interpolatedValueAtTime:(NSTimeInterval)time
{
    NSUInteger index = [self insertionIndexOfReadingForTime:time];
    NSAssert(index != NSNotFound, nil);

    if(index == 0)
        return ((COCSensorReading*)_readings.firstObject).value;     // we do not extrapolate
    else if(index == _readings.count)
        return ((COCSensorReading*)_readings.lastObject).value;     // we do not extrapolate
    else
        return [_readings[index-1]
                interpolatedValueAtTime:time
                betweenReceiverAndReading:_readings[index]];
}

- (NSUInteger)insertionIndexOfReadingForTime:(NSTimeInterval)time
{
    Class readingClass = COCSensorReading.class;
    return [_readings indexOfObject:@(time)
                      inSortedRange:NSMakeRange(0, _readings.count)
                            options:NSBinarySearchingInsertionIndex
                    usingComparator:^NSComparisonResult(id o1, id o2)
            {
                NSTimeInterval time1;
                NSTimeInterval time2;

                if([o1 isKindOfClass:readingClass])
                {
                    time1 = ((COCSensorReading*)o1).time;
                    time2 = time;
                }
                else
                {
                    time1 = time;
                    time2 = ((COCSensorReading*)o2).time;
                }

                if(time2 > time1)
                    return NSOrderedAscending;
                else if(time2 < time1)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }];
}

@end