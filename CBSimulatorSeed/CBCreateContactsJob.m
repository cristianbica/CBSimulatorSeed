//
//  CBCreateContactsJob.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "CBCreateContactsJob.h"
#define probably(n) arc4random_uniform(100)<n

@interface RHPerson (Helpers)
- (void)addEmail:(NSString *)email label:(NSString *)label;
- (void)addPhone:(NSString *)email label:(NSString *)label;
@end

@implementation RHPerson (Helpers)

- (void)addEmail:(NSString *)email label:(NSString *)label {
  RHMultiStringValue *values = [self emails];
  RHMutableMultiStringValue *mutableValues = [values mutableCopy];
  if (! mutableValues) mutableValues = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
  if (label==nil) {
    label = [@[RHWorkLabel, RHHomeLabel, RHOtherLabel] objectAtIndex:arc4random()%3];
  }
  [mutableValues addValue:email withLabel:label];
  self.emails = mutableValues;
}

- (void)addPhone:(NSString *)phone label:(NSString *)label {
  RHMultiStringValue *values = [self phoneNumbers];
  RHMutableMultiStringValue *mutableValues = [values mutableCopy];
  if (! mutableValues) mutableValues = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
  if (label==nil) {
    label = [@[RHPersonPhoneMobileLabel,
             RHPersonPhoneIPhoneLabel,
             RHPersonPhoneMainLabel,
             RHPersonPhoneHomeFAXLabel,
             RHPersonPhoneWorkFAXLabel,
             RHPersonPhoneOtherFAXLabel,
             RHPersonPhonePagerLabel] objectAtIndex:arc4random()%7];
  }
  [mutableValues addValue:phone withLabel:label];
  self.phoneNumbers = mutableValues;
}

@end


@implementation CBCreateContactsJob

- (void)performWithCompletion:(void (^)(EDQueueResult))block {
  RHAddressBook *ab = [[RHAddressBook alloc] init];
  int n = [self.data[@"count"] intValue];
  if (n<=0) {
    return;
  }
  for (int i=0; i<n; i++) {
    RHPerson *p = [ab newPersonInDefaultSource];
    [self populateRecord:p];
    //[p save];
  }
  [ab save];
  ab = nil;
  block(EDQueueResultSuccess);
}

- (void)populateRecord:(RHPerson *)person {
  if (probably(2)) {
    [self populateOrganisation:person];
  } else {
    [self populatePerson:person];
  }
}

- (void)populatePerson:(RHPerson *)person {
  person.kind = RHPersonKindPerson;
  person.firstName = [MBFakerName firstName];
  person.lastName = [MBFakerName lastName];
  if (probably(5))  person.prefix = [MBFakerName prefix];
  if (probably(5))  person.nickname = [MBFakerInternet userName];
  if (probably(95)) [person addPhone:[MBFakerPhoneNumber phoneNumber] label:RHPersonPhoneMainLabel];
  if (probably(20)) [person addPhone:[MBFakerPhoneNumber phoneNumber] label:nil];
  if (probably(60)) [person addEmail:[MBFakerInternet safeEmail] label:nil];
  if (probably(30)) [person addEmail:[MBFakerInternet safeEmail] label:nil];
  if (probably(10)) [person setImage:[self fetchPersonImage]];
    
}

- (void)populateOrganisation:(RHPerson *)person {
  person.kind = RHPersonKindOrganization;
  person.organization = [MBFakerCompany name];
  person.organization = [person.organization stringByReplacingOccurrencesOfString:@" address.suffix" withString:@""];
  person.organization = [person.organization stringByAppendingFormat:@" %@", [MBFakerCompany suffix]];
  [person addPhone:[MBFakerPhoneNumber phoneNumber] label:RHPersonPhoneMainLabel];
  [person addPhone:[MBFakerPhoneNumber phoneNumber] label:RHPersonPhoneWorkFAXLabel];
  [person setImage:[self fetchOrganisationImage]];
}

- (UIImage *)fetchPersonImage {
  return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://lorempixel.com/320/320/people/"]]];
}

- (UIImage *)fetchOrganisationImage {
  return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://lorempixel.com/320/320/business/"]]];
}



@end
