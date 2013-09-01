//
//  COCSensorDemoPlainC.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCSensorDemoPlainC.h"

static NSUInteger InitialReadingsSize = 8;

typedef struct
{
    NSTimeInterval      time;
    double              value;
    __unsafe_unretained NSUUID* sensorID;
} SensorReading;

@implementation COCSensorDemoPlainC
{
    SensorReading*  _readings;
    NSUInteger      _backSize;
    NSUInteger      _backCount;
    NSUInteger      _frontSize;
    NSUInteger      _frontCount;
}

- (void)removeAllReadings
{
    if(_readings)
    {
        free(_readings);
        _readings   = NULL;
        _backSize   = 0;
        _backCount  = 0;
        _frontSize  = 0;
        _frontCount = 0;
    }
}

- (void)addSensorReadingToBack:(SensorReading)reading
{
    if(!_readings)
    {
        _backSize = InitialReadingsSize;
        _readings = malloc(_backSize * sizeof(SensorReading));
    }
    else if(_backCount == _backSize)
    {
        _backSize = (_backSize > 0) ? _backSize * 2 : InitialReadingsSize;
        _readings = realloc(_readings, (_frontSize + _backSize) * sizeof(SensorReading));
    }

    NSAssert(_backCount < _backSize, nil);
    _readings[_frontSize + _backCount] = reading;
    _backCount++;
}

- (void)addSensorReadingToFront:(SensorReading)reading
{
    if(!_readings)
    {
        _frontSize = InitialReadingsSize;
        _readings = malloc(_frontSize * sizeof(SensorReading));
    }
    else if(_frontCount == _frontSize)
    {
       NSUInteger prevFrontSize = _frontSize;
        _frontSize = (_frontSize > 0) ? _frontSize * 2 : InitialReadingsSize;
        SensorReading* newReadings = malloc((_frontSize + _backSize) * sizeof(SensorReading));
        memcpy(newReadings + _frontSize - _frontCount,
               _readings + prevFrontSize - _frontCount,
               (_frontCount + _backCount) * sizeof(SensorReading));
        _readings = newReadings;
    }

    NSAssert(_frontCount < _frontSize, nil);
    _readings[_frontSize - _frontCount - 1] = reading;

    _frontCount++;
}

- (NSUInteger)numberOfReadings
{
    return _frontCount + _backCount;
}

- (SensorReading*)readingAtIndex:(NSUInteger)index
{
    NSParameterAssert(index < _frontSize + _backSize);
    return &_readings[_frontSize - _frontCount + index];
}

- (NSTimeInterval)earliestTime
{
    if(self.numberOfReadings > 0)
        return [self readingAtIndex:0]->time;
    else
        return self.defaultTime;
}

- (NSTimeInterval)latestTime
{
    NSUInteger count = self.numberOfReadings;
    if(count > 0)
        return [self readingAtIndex:count-1]->time;
    else
        return self.defaultTime;
}

- (void)appendBatchOfSensorReadings
{
    [self.class provideRandomValues:self.batchSize
                          startTime:self.latestTime
                         usingBlock:^(NSTimeInterval iTime, double iValue, NSUUID* iSensorID) {
                             SensorReading reading = {iTime, iValue, iSensorID};
                             [self addSensorReadingToBack:reading];
                         }];
}

- (void)prependBatchOfSensorReadings
{
    [self.class provideRandomValues:-self.batchSize
                          startTime:self.earliestTime
                         usingBlock:^(NSTimeInterval iTime, double iValue, NSUUID* iSensorID) {
                             SensorReading reading = {iTime, iValue, iSensorID};
                             [self addSensorReadingToFront:reading];
                         }];
}

- (double)interpolatedValueAtTime:(NSTimeInterval)time
{
    NSUInteger index = [self insertionIndexOfReadingForTime:time];
    NSAssert(index != NSNotFound, nil);

    NSUInteger count = self.numberOfReadings;
    if(index == 0)
        return [self readingAtIndex:0]->value;           // we do not extrapolate
    else if(index == count)
        return [self readingAtIndex:count]->value;      // we do not extrapolate
    else
        return [self interpolatedValueAtTime:time
                              betweenReading:[self readingAtIndex:index-1]
                                  andReading:[self readingAtIndex:index]];
}

- (double)interpolatedValueAtTime:(NSTimeInterval)interpolationTime
                   betweenReading:(SensorReading*)readingA
                       andReading:(SensorReading*)readingB
{
    NSParameterAssert(readingA);
    NSParameterAssert(readingB);

    NSTimeInterval timeA = readingA->time;
    NSTimeInterval timeB = readingB->time;
    double valueA = readingA->value;
    double valueB = readingB->value;
    return valueA + (valueB - valueA) * (interpolationTime - timeA) / (timeB - timeA);
}

- (NSInteger)insertionIndexOfReadingForTime:(NSTimeInterval)time
{
    return [self insertionIndexOfReadingForTime:time
                                       minIndex:0
                                       maxIndex:self.numberOfReadings];
}

- (NSInteger)insertionIndexOfReadingForTime:(NSTimeInterval)searchTime
                                   minIndex:(NSInteger)minIndex
                                   maxIndex:(NSInteger)maxIndex
{
    if (maxIndex < minIndex)
        return minIndex;

    NSInteger midIndex = (minIndex + maxIndex) / 2;
    NSTimeInterval timeAtMidIndex = [self readingAtIndex:midIndex]->time;
    if(searchTime == timeAtMidIndex)
        return midIndex;
    else if(timeAtMidIndex > searchTime)
        return [self insertionIndexOfReadingForTime:searchTime
                                           minIndex:minIndex
                                           maxIndex:midIndex - 1];
    else
        return [self insertionIndexOfReadingForTime:searchTime
                                           minIndex:midIndex + 1
                                           maxIndex:maxIndex];
}
@end