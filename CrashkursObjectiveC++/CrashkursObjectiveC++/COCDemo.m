//
//  COCDemo.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCDemo.h"

@implementation COCDemo

- (double)executionTimeOfBlock:(void (^)())block
{
    NSParameterAssert(block);

    NSDate* date = [NSDate date];
    block();
    return -date.timeIntervalSinceNow;
}

- (void)run
{
    NSAssert(NO, @"abstract");
}
@end
