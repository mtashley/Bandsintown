//
//  DetailVC.m
//  Bandsintown
//
//  Created by Ashley on 10/16/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

#import "DetailViewController.h"
#import "Bandsintown-Swift.h"
#import <Kingfisher/KingFisher-Swift.h>

@interface DetailViewController() <DataManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tracker;
@property (weak, nonatomic) IBOutlet UILabel *lbl_events;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DataManager *sharedDataManager = [DataManager sharedInstance];
    sharedDataManager.delegate = self;
}

- (void)presentArtistDetailsWith:(Artist *)artist {
    
    self.navigationItem.title = artist.name.uppercaseString;
    self.lbl_name.text = artist.name.uppercaseString;
    self.lbl_tracker.text = [NSString stringWithFormat:@"%i TRACKERS",  (int)artist.tracker_count];
    self.lbl_events.text = [NSString stringWithFormat:@"%i EVENTS UPCOMING", (int)artist.upcoming_event_count];
 }

@end
