//
//  EventDetailsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "EventDetailsController.h"
#import "KSGuiUtilities.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "VoucherDetailController.h"

#define kjsonURL @"eventDetail.php?event_id="
#define kTableBG @"bg_tableView.png"
#define kTitle @"Event Details"

@interface EventDetailsController ()

@end

@implementation EventDetailsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [app AddloadingView];
    [self launchLoadData];
}

#pragma mark - launchLoadData and loadData are for a new thread
-(void)launchLoadData {
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    [self decorateView];
    [self displayValues];
}

- (void)decorateView{
    
    [self setBackButton];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor  colorWithRed:(24/255.0) green:(24/255.0) blue:(24/255.0) alpha:1];
    
}

#pragma mark - displaying data
- (void)displayValues {
    
    //preparing values
    NSString *dateDetail = [KSUtilities getFormatedDate:_eventDetail.date];
    NSString *subTitle = [NSString stringWithFormat:@"Date: %@\rVenue: %@",dateDetail,_eventDetail.venueName];
    UIImage *eventImage = [KSUtilities getImage:_eventDetail.photo];
    NSLog(@"eventDetail/displayValues: date= %@ id=%@",_eventDetail.date,_eventDetail.eventId);
    [KSBadgeManager addViewedEvent:[NSMutableString stringWithString:_eventDetail.eventId] onDate:[NSMutableString stringWithString:_eventDetail.date]];
    
    // setting values
    self.titleLabel.text = _eventDetail.eventName;
    self.subTitleLabel.text = subTitle;
    self.eventImageView.image = eventImage;
 
    // description label is created programmatically
    CGRect descFrame = CGRectMake(12, 360, 290, 600);
    UILabel *descLabel = [[UILabel alloc] initWithFrame:descFrame];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.backgroundColor = [UIColor clearColor];
   [descLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    descLabel.text = _eventDetail.eventDescription;
    
    // Tell the label to use an unlimited number of lines
    [descLabel setNumberOfLines:0];
    [descLabel sizeToFit];
    [self.view    addSubview:descLabel ];

    // adding the voucher button
    UIImage *buttonBackground = [UIImage imageNamed:@"buttonVoucher.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"buttonVoucher.png"];
    CGRect frame = CGRectMake(100.0, 320.0, 100.0, 35.0);
    UIButton *button = [KSGuiUtilities buttonWithTitle:@""
                                                target:self
                                              selector:@selector(voucherAction)
                                                 frame:frame
                                                 image:buttonBackground
                                          imagePressed:buttonBackgroundPressed
                                         darkTextColor:YES];
    
    [self.view addSubview:button];


    // adding reminder button
    UIImage *btnRemindMe = [UIImage imageNamed:@"buttonRemindMe.png"];
    CGRect frame1= CGRectMake(200.0, 5.0, 80.0, 25.0);
    UIButton *remindButton = [KSGuiUtilities buttonWithTitle:@"Remind Me"
                                                target:self
                                              selector:@selector(addToCalendar:)
                                                 frame:frame1
                                                 image:btnRemindMe
                                          imagePressed:btnRemindMe
                                         darkTextColor:NO];
    UIBarButtonItem *remindButtonItem = [[UIBarButtonItem alloc] initWithCustomView:remindButton];
    
    self.navigationItem.rightBarButtonItem = remindButtonItem;
    [app RemoveLoadingView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.topViewController.title  = kTitle;
}

-(void)viewWillDisappear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Calender Entry
- (void) addToCalendar:(id) sender{
    [self processEvent];
    }

- (void) processEvent {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    // display error message here
                    
                }
                else if (!granted){
                    // display access denied error message here
                    
                }
                else {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    // accessing the event store for an event
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    

                    
                    //getting values
                    NSString *title = _eventDetail.eventName;
                    NSString *venue = _eventDetail.venueName;
                    NSString *date = _eventDetail.date;
                    NSString *description = _eventDetail.eventDescription;
                    
                    // setting values to an event
                    event.title= title;
                    event.location = venue;
                    event.notes = description;
                    
                    //start date
                    NSString *strStartDate = [NSString stringWithFormat:@"%@ 22:00:00",date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *startDate = [formatter dateFromString:strStartDate];
                    event.startDate =startDate;
                    
                    //end date
                    NSString *strEndDate = [NSString stringWithFormat:@"%@ 23:59:59",date];
                    NSDate *endDate = [formatter dateFromString:strEndDate];
                    event.endDate= endDate;
                    
                    //alarm date
                    NSString *strAlarmDate = [NSString stringWithFormat:@"%@ 13:00:00",date];
                    NSDate *alarmDate = [formatter dateFromString:strAlarmDate];
                    NSArray *arrAlarm = [NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:alarmDate]];
                    event.alarms= arrAlarm;
                    
                    
                    // geting all the events and checking if the current event is already in thee calendar
//---------------------------------------------------------------------------------------------------------------------------------
                    
                    // Create the predicate from the event store's instance method
                    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                                                                                 endDate:endDate
                                                                               calendars:nil];
                    
                    // Fetch all events that match the predicate
                    NSArray *eventList = [eventStore eventsMatchingPredicate:predicate];
                    
                    Boolean eventExists = FALSE;
                    
                    for(int i=0; i < eventList.count; i++){
                        
                      
                        
                        if ([title isEqualToString:[[eventList objectAtIndex:i] title]]) {
                            eventExists = TRUE;
                        }
                        
                    }
                    
//---------------------------------------------------------------------------------------------------------------------------------
                    
                    //setting the event in the calendar
            if (!eventExists){
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    BOOL isSuceess=[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    if(isSuceess){
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Event : Success " message:@"This event has been added in your calendar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertview show];
                    }
                    else{
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Event : Error" message:[err description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertview show];
                        
                    }
            } else {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Event : Exists" message:@"This event already exsists in your calendar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

                [alertview show];
            }
                    
                }
            });
        }];
    }
    else {
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
        
    }
}


- (void) eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action {
}

#pragma mark - Back button;
-(void) setBackButton {
    UIButton *btn = [KSUtilities getBackButton];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)voucherAction {
    VoucherDetailController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"voucher"];
    nextViewController.eventDetail = _eventDetail;
    [self.navigationController pushViewController:nextViewController animated: NO];
}

@end
