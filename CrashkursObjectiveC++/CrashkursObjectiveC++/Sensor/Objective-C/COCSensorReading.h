//
//  COCSensorReading.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 23.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

@interface COCSensorReading : NSObject

@property (nonatomic, readonly)     NSTimeInterval  time;
@property (nonatomic, readonly)     double          value;
@property (nonatomic, readonly)     NSUUID*         sensorID;

- (id)initWithTime:(NSTimeInterval)time
             value:(double)value
          sensorID:(NSUUID*)sensorID;

- (double)interpolatedValueAtTime:(NSTimeInterval)time
        betweenReceiverAndReading:(COCSensorReading*)targetReading;

@end