//
//  KSVoucherDetailController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 03/07/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSVoucherDetailController.h"
#import "KSJson.h"
#import "KSGuiUtilities.h"
#import "KSUtilities.h"
#import "KSUsedVoucher.h"
#import "KSUsedVoucherManager.h"

#define kTitle @"Voucher"




@interface KSVoucherDetailController ()

@end



@implementation KSVoucherDetailController

@synthesize scanButton;
@synthesize eventDetailDict;

Boolean used = false;
Boolean active = false;
UILabel *warningLabel;
NSString *eventId ;
NSString *venueId ;
NSString *venueName ;
NSString *voucherDescription;
NSString *date;
NSString *voucherPhotoUrl;
KSUsedVoucherManager *usedVoucherManager ;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButton];
    self.navigationController.topViewController.title  = kTitle;
    usedVoucherManager= [[KSUsedVoucherManager alloc]init];

    eventId = _eventDetail.eventId;
    venueId = _eventDetail.venueId;  //todo venue id
    voucherDescription = _eventDetail.voucherDescription; //todo
    date = _eventDetail.date;
    voucherPhotoUrl = _eventDetail.voucherPhoto; //todo
    UIImage *voucherPhoto = [KSUtilities getImage:voucherPhotoUrl];

    venueName = _eventDetail.venueName;
    UIImage *photo = [KSUtilities getImage:_eventDetail.logo];
    
    // venue logo 
    CGRect photoFrame = CGRectMake(5, 20, 72, 72);
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:photoFrame] ;
    [photoView setImage:photo];
    [self.view addSubview:photoView ];
    
    // venue name 
    CGRect venueNameFrame = CGRectMake(90, 20, 213, 35);
    UILabel *venueNameLabel = [[UILabel alloc] initWithFrame:venueNameFrame];
    venueNameLabel.textColor = [UIColor whiteColor];
    venueNameLabel.backgroundColor = [UIColor clearColor];
    [venueNameLabel setFont:[UIFont fontWithName:@"Harabara" size:16]];
    venueNameLabel.text = venueName;
    [self.view addSubview:venueNameLabel]; 
    
    // event title
    CGRect eventTitleFrame = CGRectMake(90, 55, 213, 35);
    UILabel *eventTitleLabel = [[UILabel alloc] initWithFrame:eventTitleFrame];
    eventTitleLabel.textColor = [UIColor whiteColor];
    eventTitleLabel.backgroundColor = [UIColor clearColor];
    [eventTitleLabel setFont:[UIFont fontWithName:@"Harabara" size:16]];
    eventTitleLabel.text = _eventDetail.eventName;
    [self.view addSubview:eventTitleLabel];


    // vhoucher photo
    CGRect voucherPhotoFrame = CGRectMake(5, 120, 310, 200);
    UIImageView *voucherView = [[UIImageView alloc] initWithFrame:voucherPhotoFrame] ;
    [voucherView setImage:voucherPhoto];
    [self.view addSubview:voucherView ];

    // voucher description
    NSString * description = @"If you present this voucher to the venue, you will be able to get 5% discount. Please note that it  can be used only once.";
    CGRect descFrame = CGRectMake(12, 330, 290, 350);
    UILabel *descLabel = [[UILabel alloc] initWithFrame:descFrame];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.backgroundColor = [UIColor clearColor];
    [descLabel setFont:[UIFont fontWithName:@"Harabara" size:16]];
    descLabel.text = description;
    descLabel.text = voucherDescription;   //todo activate it after discussing with Ramzy

    [descLabel setNumberOfLines:0];
    [descLabel sizeToFit];
    [self.view    addSubview:descLabel ];

    used = (Boolean)[usedVoucherManager isUsed:eventId];

    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *todayString = [dateFormat stringFromDate:today];
    if ([date isEqualToString:todayString]) {
        active = true;
        NSLog(@"date now =%@", todayString);
    } else {
        active = false;
    }

    if (!used && active){
        [self addScanButton];
    } else if (used && active) {
        [self addWarningLabel:@"VOUCHER USED !!! "] ;
    } else {
        [self addWarningLabel:[NSString stringWithFormat:@"KSVoucherDetailController valid on %@",date] ];
    }

}

- (void) addScanButton {
    UIImage *buttonBackground = [UIImage imageNamed:@"buttonScan.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"buttonScan.png"];
    
    CGRect frame = CGRectMake(115.0, 390.0, 100.0, 35.0);
    scanButton = [KSGuiUtilities buttonWithTitle:@""
                                                   target:self
                                                 selector:@selector(scanButtonPress:)
                                                    frame:frame
                                                    image:buttonBackground
                                             imagePressed:buttonBackgroundPressed
                                            darkTextColor:YES];
    
    [self.view addSubview:scanButton];
}

-(void)addWarningLabel:(NSString *)text {
        CGRect usedFrame = CGRectMake(10, 390, 300, 35);
        warningLabel = [[UILabel alloc] initWithFrame:usedFrame];
        warningLabel.textColor = [UIColor yellowColor];
        warningLabel.backgroundColor = [UIColor clearColor];
        [warningLabel setFont:[UIFont fontWithName:@"American Typewriter" size:16]];
        warningLabel.text = text;
        [warningLabel setTextAlignment:NSTextAlignmentCenter];
        [warningLabel setNumberOfLines:0];
    [self.view addSubview:warningLabel];
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark Barcode Reader (ZBarReader)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)scanButtonPress:(id)sender{
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;
    
    [self presentModalViewController: reader animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];

    ZBarSymbol *symbol = nil;
    
    for(symbol in results){
        
        NSString *qrString = symbol.data;
        NSData *qrData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        NSDictionary* qrDict = [NSJSONSerialization JSONObjectWithData:qrData options:kNilOptions error:&error];
        
        NSString *id = [qrDict objectForKey:@"id"];
        NSString *type = [qrDict objectForKey:@"type"];
        NSString *action= [qrDict objectForKey:@"action"];
        NSString *venue= [qrDict objectForKey:@"venue"];
        
    
        NSString *combined = [NSString stringWithFormat:@" Scanned: id=%@,  type=%@,  action=%@, venue=%@", id, type, action, venue];
        NSLog(@"voucher: combined qr variables =  %@",combined);

        // if id and type and action ok, then show view  as success and update the database
        if ([id isEqualToString:@"cnapp"]
            && [type isEqualToString:@"voucher" ]
            && [venue isEqualToString:venueId ]
            && [action isEqualToString:@"cancel"]){


            // showing confirmation pop up
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!!!" message:[NSString stringWithFormat:@"Thank you for using  CNAPP voucher"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

            used = true;
            [scanButton removeFromSuperview];
            [self addWarningLabel:@"VOUCHER USED!!!"];

            // updates the used voucher
            KSUsedVoucher * usedVoucher = [[KSUsedVoucher alloc]init];
            usedVoucher.eventId = eventId;
            [usedVoucherManager addUsedVoucher:usedVoucher];

//            [self addUsed:eventId];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:[NSString stringWithFormat:@"Wrong QR Code"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    
        [reader dismissModalViewControllerAnimated: YES];
        
    }
    
    
}

#pragma mark PLIST related
- (NSDictionary *) readDict {
    NSString *fiePath = [self getFilePath];
    NSLog (@"%@",fiePath);
    if ([NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:fiePath]] !=nil) {
        return   [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:fiePath]];
    } else{
        return  nil;
    }
}

- (void) writeDict: (NSDictionary *)existingDict {
    NSString *error;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:existingDict  format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:[self getFilePath] atomically:YES];
    } else {
        NSLog(error);
    }
}


- (Boolean) isUsed:(NSString *)eventId {
    NSDictionary *voucherDict = [self readDict];
    if (voucherDict != nil) {
        Boolean eventUsed = (Boolean) [voucherDict objectForKey:eventId];
        return eventUsed;
    }  else {
      return NO;
    }
}

- (void) addUsed: (NSString *)eventId {
    NSDictionary *voucherDict = [self readDict];
    NSMutableDictionary *mutableVoucherDict = [voucherDict mutableCopy];
    if (mutableVoucherDict == nil) {
        mutableVoucherDict= [NSMutableDictionary dictionary];
    }
    [mutableVoucherDict setObject:@YES forKey:eventId];
    voucherDict = [NSMutableDictionary dictionaryWithDictionary:mutableVoucherDict];
    [self writeDict:voucherDict];
}

- (NSString *) getFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [basePath stringByAppendingPathComponent:@"voucher.plist"];
    return filePath;
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

@end
