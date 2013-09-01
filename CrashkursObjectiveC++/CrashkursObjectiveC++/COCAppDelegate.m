//
//  COCAppDelegate.m
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 23.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

#import "COCAppDelegate.h"
#import "COCSensorDemoObjC.h"
#import "COCSensorDemoObjCPP.h"
#import "COCSensorDemoPlainC.h"
#import "COCCacheDemoObjC.h"
#import "COCCacheDemoObjCPP.h"

typedef struct
{
    int a;
    int b;
} MyStruct;

@implementation COCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.sensorDemoObjC   = [[COCSensorDemoObjC   alloc] init];
    self.sensorDemoObjCPP = [[COCSensorDemoObjCPP alloc] init];
    self.sensorDemoPlainC = [[COCSensorDemoPlainC alloc] init];
    self.cacheDemoObjC    = [[COCCacheDemoObjC    alloc] init];
    self.cacheDemoObjCPP  = [[COCCacheDemoObjCPP  alloc] init];
}

- (IBAction)runSensorDemoObjC:(id)sender
{
    [self.sensorDemoObjC run];
}

- (IBAction)runSensorDemoObjCpp:(id)sender
{
    [self.sensorDemoObjCPP run];
}

- (IBAction)runSensorDemoPlainC:(id)sender
{
    [self.sensorDemoPlainC run];
}

- (IBAction)runCacheDemoObjC:(id)sender;
{
    [self.cacheDemoObjC run];
}

- (IBAction)runCacheDemoObjCPP:(id)sender;
{
    [self.cacheDemoObjCPP run];
}

@end