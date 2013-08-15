//
//  ViewController.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "ViewController.h"
#import "CBAsyncJob.h"
#import <EDQueueStorageEngine.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface EDQueue ()
@property EDQueueStorageEngine *engine;
@end

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *jobs;
@property (nonatomic) int totalJobs;
@property (nonatomic) int doneJobs;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[EDQueue sharedInstance] empty];
  [[EDQueue sharedInstance] start];
  [[EDQueue sharedInstance] setDelegate:self];
  self.jobs = [[NSMutableArray alloc] initWithCapacity:10];
  [[NSNotificationCenter  defaultCenter] addObserverForName:EDQueueJobDidSucceed object:nil queue:nil usingBlock:^(NSNotification *note) {
    NSLog(@"JOB SUCCEED: %@", note.object);
    if ([[note.object objectForKey:@"task"] isEqualToString:@"seed"]) {
      [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
      self.totalJobs = [[[EDQueue sharedInstance] engine] fetchJobCount]-1;
      self.doneJobs = 0;
    } else  if ([[note.object objectForKey:@"task"] isEqualToString:@"seed-finished"]) {
      [SVProgressHUD dismiss];
    } else {
      self.doneJobs++;
      [SVProgressHUD showProgress:(float)self.doneJobs/(float)self.totalJobs
                           status:[NSString stringWithFormat:@"%@ (%d%%)",
                                   [[note.object[@"task"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalize],
                                   (int)round((float)self.doneJobs/(float)self.totalJobs*100)]];
    }
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [[EDQueue sharedInstance] stop];
  [[EDQueue sharedInstance] empty];
  [self.jobs removeAllObjects];
  [self setContactsCountLabel:nil];
  [self setContactsSwitch:nil];
  [self setPhotosCountLabel:nil];
  [self setPhotosSwitch:nil];
  [self setDeleteContactsSwitch:nil];
  [super viewDidUnload];
}
- (IBAction)didChangePhotosCount:(id)sender {
  float val = self.photosSwitch.value;
  val = roundf(val);
  self.photosSwitch.value = val;
  self.photosCountLabel.text = @(val).stringValue;
}

- (IBAction)didChangeContactsCount:(id)sender {
  float val = self.contactsSwitch.value;
  val = roundf(val);
  self.contactsSwitch.value = val;
  self.contactsCountLabel.text = @(val).stringValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"seed"]) {
    [self seed];
  }
}

- (void)seed {
  NSDictionary *data = @{
                         @"delete-contacts" : @(self.deleteContactsSwitch.isOn),
                         @"contacts" : @(self.contactsSwitch.value),
                         @"photos" : @(self.photosSwitch.value)
                         };
  [[EDQueue sharedInstance] enqueueWithData:data forTask:@"seed"];
}

- (void)queue:(EDQueue *)queue processJob:(NSDictionary *)job completion:(void (^)(EDQueueResult result))block {
  NSLog(@"GOT JOB: %@", job);
  NSString *className = [NSString stringWithFormat:@"CB%@Job", [job[@"task"] camelize]];
  Class klass = NSClassFromString(className);
  __block CBAsyncJob *ajob = [[klass alloc] initWithData:job[@"data"]];
  if (!ajob) {
    block(EDQueueResultSuccess);
    return;
  }
  [self.jobs addObject:ajob];
  __weak __typeof(&*self)weakSelf = self;
  [ajob performWithCompletion:^(EDQueueResult result) {
    block(result);
    [weakSelf.jobs removeObject:ajob];
  }];
}

@end
