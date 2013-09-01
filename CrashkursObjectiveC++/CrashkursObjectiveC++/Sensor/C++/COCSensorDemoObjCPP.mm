//
//  COCSensorDemoObjCPP.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCSensorDemoObjCPP.h"
#import <deque>
#import <algorithm>

struct SensorReading
{
    NSTimeInterval  time;
    double          value;
    NSUUID*         sensorID;

    double interpolatedValue(NSTimeInterval interpolationTime,
                             SensorReading& nextReading)
    {
        NSCParameterAssert(time <= interpolationTime);
        NSCParameterAssert(nextReading.time >= interpolationTime);

        return value + (nextReading.value - value)
        * (interpolationTime - time) / (nextReading.time - time);
    }
};

@implementation COCSensorDemoObjCPP
{
    std::deque<SensorReading> _readings;
}

- (void)removeAllReadings
{
    _readings.clear();
}

- (NSTimeInterval)earliestTime
{
    if(_readings.size() > 0)
        return _readings.front().time;
    else
        return self.defaultTime;
}

- (NSTimeInterval)latestTime
{
    if(_readings.size() > 0)
        return _readings.back().time;
    else
        return self.defaultTime;
}

- (void)appendBatchOfSensorReadings
{
    [self.class provideRandomValues:self.batchSize
                          startTime:self.earliestTime
                         usingBlock:^(NSTimeInterval iTime,
                                      double iValue,
                                      NSUUID* iSensorID)
     {
         _readings.push_back({ iTime, iValue, iSensorID});
     }];
}

- (void)prependBatchOfSensorReadings
{
    [self.class provideRandomValues:-self.batchSize
                          startTime:self.latestTime
                         usingBlock:^(NSTimeInterval iTime,
                                      double iValue,
                                      NSUUID* iSensorID)
     {
         _readings.push_front({ iTime, iValue, iSensorID});
     }];
}

- (double)interpolatedValueAtTime:(NSTimeInterval)time
{
    auto insert = std::lower_bound(_readings.begin(),
                                   _readings.end(),
                                   time,
                                   [] (const SensorReading& reading,
                                       double iTime) {
                                       return reading.time < iTime;
                                   });

    if(insert == _readings.begin())
        return (*insert).value;          // we do not extrapolate
    else if(insert == _readings.end())
        return (*(insert-1)).value;      // we do not extrapolate
    else
        return (*(insert-1)).interpolatedValue(time, *insert);
}

@end