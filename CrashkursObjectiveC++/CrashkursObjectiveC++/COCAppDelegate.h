//
//  COCAppDelegate.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 23.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

@class COCSensorDemoObjC;
@class COCSensorDemoObjCPP;
@class COCSensorDemoPlainC;
@class COCCacheDemoObjC;
@class COCCacheDemoObjCPP;

@interface COCAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readwrite, strong) IBOutlet NSWindow* window;

@property (nonatomic, readwrite, strong) COCSensorDemoObjC*     sensorDemoObjC;
@property (nonatomic, readwrite, strong) COCSensorDemoObjCPP*   sensorDemoObjCPP;
@property (nonatomic, readwrite, strong) COCSensorDemoPlainC*   sensorDemoPlainC;

- (IBAction)runSensorDemoObjC:(id)sender;
- (IBAction)runSensorDemoObjCpp:(id)sender;
- (IBAction)runSensorDemoPlainC:(id)sender;

@property (nonatomic, readwrite, strong) COCCacheDemoObjC*      cacheDemoObjC;
@property (nonatomic, readwrite, strong) COCCacheDemoObjCPP*    cacheDemoObjCPP;


- (IBAction)runCacheDemoObjC:(id)sender;
- (IBAction)runCacheDemoObjCPP:(id)sender;

@end
