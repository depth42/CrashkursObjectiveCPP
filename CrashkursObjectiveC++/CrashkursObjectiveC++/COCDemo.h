//
//  COCDemo.h
//  CrashkursObjectiveC++
//
//  Created by Frank Illenberger on 26.08.13.
//  Copyright (c) 2013 ProjectWizards. All rights reserved.
//

@interface COCDemo : NSObject

- (double)executionTimeOfBlock:(void (^)())block;

- (void)run;

@end
