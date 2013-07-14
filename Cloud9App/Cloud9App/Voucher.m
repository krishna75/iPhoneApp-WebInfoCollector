//
//  Voucher.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 03/07/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "Voucher.h"
#import "KSJson.h"




@interface Voucher ()

@end



@implementation Voucher

@synthesize scanButton;
Boolean used = false;
UIButton *scanButton;
UILabel *usedLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

//    create voucher description
    NSString *description = @"If you present this voucher to the venue, you will be able to get 5% discount. Please note that it  can be used only once.";
    CGRect descFrame = CGRectMake(12, 200, 290, 350);
    UILabel *descLabel = [[UILabel alloc] initWithFrame:descFrame];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.backgroundColor = [UIColor clearColor];
    [descLabel setFont:[UIFont fontWithName:@"American Typewriter" size:16]];
    descLabel.text = description;
    [descLabel setNumberOfLines:0];
    [descLabel sizeToFit];
    [self.view    addSubview:descLabel ];


    // adding scan button
    // adding voucher button
    if (!used){
        [self addScanButton];
    } else {
        [self addUsedLabel] ;
    }

}

- (void) addScanButton {
        scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [scanButton addTarget:self action:@selector(scanButtonPress:) forControlEvents:UIControlEventTouchDown];
        [scanButton setTitle:@"Scan QR Code" forState:UIControlStateNormal];
        scanButton.frame = CGRectMake(30.0, 300.0, 260.0, 50.0);
        [self.view addSubview:scanButton];
}

-(void) addUsedLabel{
        NSString *usedText = @"Voucher Used !!!.";
        CGRect usedFrame = CGRectMake(80, 300, 160, 50);
        usedLabel = [[UILabel alloc] initWithFrame:usedFrame];
        usedLabel.textColor = [UIColor yellowColor];
        usedLabel.backgroundColor = [UIColor clearColor];
        [usedLabel setFont:[UIFont fontWithName:@"American Typewriter" size:25]];
        usedLabel.text = usedText;
        [usedLabel setNumberOfLines:0];
        [usedLabel sizeToFit];
        [self.view    addSubview:usedLabel ];
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

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
        
    
        NSString *combined = [NSString stringWithFormat:@" Scanned: id=%@,  type=%@,  action=%@", id, type, action];
        NSLog(@"combined qr variables =  %@",combined);

        // if id and type and action ok, then show view  as success and update the database
        if ([id isEqualToString:@"cnapp"] && [type isEqualToString:@"voucher" ] && [action isEqualToString:@"cancel"]){

            // updating the voucher used
            KSJson * json = [[KSJson alloc] init];
            NSString *url =  @"model_addVoucher.php?user_id=cloudnineapp-voucher&password=App@Cloud9&event_id=";
            NSString *jsonURL  = [url stringByAppendingString:_event_id];
            NSLog(@"voucher url = %@" ,jsonURL);
            [json toArray:jsonURL];

            // showing confirmation pop up
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!!!" message:[NSString stringWithFormat:@"Thank you for using  CNAPP voucher"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

            used = true;
            [scanButton removeFromSuperview];
            [self addUsedLabel];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:[NSString stringWithFormat:@"Wrong QR Code"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    
        [reader dismissModalViewControllerAnimated: YES];
        
    }
    
    
}

@end
