//
//  CBAsyncJob.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "CBAsyncJob.h"

@implementation CBAsyncJob

- (id)initWithData:(NSDictionary *)data {
  self = [super init];
  if (self) {
    self.data = data;
  }
  return self;
}
- (void)performWithCompletion:(void (^)(EDQueueResult result))block {
  block(EDQueueResultSuccess);
}

@end
