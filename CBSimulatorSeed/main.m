//
//  main.m
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#if TARGET_IPHONE_SIMULATOR
int main(int argc, char *argv[])
{
  @autoreleasepool {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
#endif