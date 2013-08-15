//
//  CBDeleteContactsJob.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "CBDeleteContactsJob.h"

@implementation CBDeleteContactsJob

- (void)performWithCompletion:(void (^)(EDQueueResult))block {
  __block RHAddressBook *ab = [[RHAddressBook alloc] init];
  [[ab people] each:^(RHPerson *person) {
    [ab removePerson:person];
  }];
  [ab save];
  ab = nil;
  block(EDQueueResultSuccess);
}

@end
