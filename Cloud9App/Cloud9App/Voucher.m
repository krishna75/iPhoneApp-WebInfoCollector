//
//  Voucher.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 03/07/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "Voucher.h"
#import "KSBackgroundLayer.h"

@interface Voucher ()

@end



@implementation Voucher

@synthesize scanButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
//	CAGradientLayer *bgLayer = [KSBackgroundLayer greyGradient];
//    bgLayer.frame = self.view.bounds;
//    [self.view.layer insertSublayer:bgLayer atIndex:0];
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
        
        NSString *upcString = symbol.data;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scanned UPC" message:[NSString stringWithFormat:@"The UPC read was: %@", upcString] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        [reader dismissModalViewControllerAnimated: YES];
        
    }
    
    
}

@end
