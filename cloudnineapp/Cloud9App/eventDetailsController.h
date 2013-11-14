//
//  EventDetailsController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class DailyEvents;
@class EventDetail;

@interface EventDetailsController : UIViewController<EKEventViewDelegate> {
    
}

@property (retain, nonatomic) NSString *eventId;
@property (retain, nonatomic) IBOutlet UILabel  *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel  *subTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel  *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIImageView  *eventImageView;
@property (retain, nonatomic) EventDetail* eventDetail;

- (void) addToCalendar:(id) sender;
//- (IBAction) createEvent;

@end
