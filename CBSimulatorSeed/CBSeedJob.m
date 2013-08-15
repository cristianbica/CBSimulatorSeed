//
//  CBSeedJob.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "CBSeedJob.h"

@implementation CBSeedJob

- (void)performWithCompletion:(void (^)(EDQueueResult result))block {
  [self performSelectorOnMainThread:@selector(scheduleJobsWithData:) withObject:self.data waitUntilDone:YES];
  block(EDQueueResultSuccess);
}

- (void)scheduleJobsWithData:(NSDictionary *)data {
  if ([self.data[@"delete-contacts"] boolValue]) {
    [[EDQueue sharedInstance] enqueueWithData:nil forTask:@"delete_contacts"];
  }
//  if ([self.data[@"delete-photos"] boolValue]) {
//    [[EDQueue sharedInstance] enqueueWithData:nil forTask:@"delete_photos"];
//  }
  if ([self.data[@"contacts"] integerValue]>0) {
    for (int i=0; i<[self.data[@"contacts"] integerValue]; i++) {
      [[EDQueue sharedInstance] enqueueWithData:@{@"count": @(1)} forTask:@"create_contacts"];
    }
//    [[EDQueue sharedInstance] enqueueWithData:@{@"count": self.data[@"contacts"]} forTask:@"create_contacts"];
  }
  if ([self.data[@"photos"] integerValue]>0) {
    for (int i=0; i<[self.data[@"photos"] integerValue]; i++) {
      [[EDQueue sharedInstance] enqueueWithData:@{@"count": @(1)} forTask:@"create_photos"];
    }
//    [[EDQueue sharedInstance] enqueueWithData:@{@"count": self.data[@"photos"]} forTask:@"create_photos"];
  }
  [[EDQueue sharedInstance] enqueueWithData:nil forTask:@"seed-finished"];
}

@end
