//
//  CBAsyncJob.h
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBAsyncJob : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)data;
- (void)performWithCompletion:(void (^)(EDQueueResult result))block;

@end
