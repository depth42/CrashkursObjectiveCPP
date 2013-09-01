//
//  COCSensorReading.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 23.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCSensorReading.h"

@implementation COCSensorReading

- (id)initWithTime:(NSTimeInterval)time
             value:(double)value
          sensorID:(NSUUID*)sensorID
{
    NSParameterAssert(sensorID);

    if(self = [super init]) {
        _time       = time;
        _value      = value;
        _sensorID   = sensorID;
    }
    return self;
}

- (double)interpolatedValueAtTime:(NSTimeInterval)interpolationTime
        betweenReceiverAndReading:(COCSensorReading*)nextReading
{
    NSParameterAssert(self.time <= interpolationTime);
    NSParameterAssert(nextReading);
    NSParameterAssert(nextReading.time >= interpolationTime);

    NSTimeInterval timeA = self.time;
    NSTimeInterval timeB = nextReading.time;
    double valueA = self.value;
    double valueB = nextReading.value;

    return valueA + (valueB - valueA) * (interpolationTime - timeA) / (timeB - timeA);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Reading: time = %@, value = %@", @(_time), @(_value)];
}

@end