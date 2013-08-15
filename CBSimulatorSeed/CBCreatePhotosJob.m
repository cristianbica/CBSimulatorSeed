//
//  CBCreatePhotosJob.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import "CBCreatePhotosJob.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CBCreatePhotosJob

- (void)performWithCompletion:(void (^)(EDQueueResult))block {
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://lorempixel.com/640/960"]];
  [library writeImageDataToSavedPhotosAlbum:imageData
                                   metadata:nil
                            completionBlock:^(NSURL *assetURL, NSError *error) {
                              NSLog(@"%@ %@", assetURL, error);
                              block(EDQueueResultSuccess);
                            }];
}

@end
