//
//  ViewController.h
//  CBSimulatorSeed
//
//  Created by Cristian Bica on 8/14/13.
//  Copyright (c) 2013 Cristian Bica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <EDQueueDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *deleteContactsSwitch;
@property (strong, nonatomic) IBOutlet UILabel *contactsCountLabel;
@property (strong, nonatomic) IBOutlet UISlider *contactsSwitch;
@property (strong, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (strong, nonatomic) IBOutlet UISlider *photosSwitch;

- (IBAction)didChangePhotosCount:(id)sender;
- (IBAction)didChangeContactsCount:(id)sender;

@end
