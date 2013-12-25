//
//  KSSettingsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 21/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSSettingsController.h"
#import "KSJson.h"
#import "KSSettingsDetail.h"
#import "AppDelegate.h"
#import "KSInternetManager.h"


#define kUrlGenres @"events.php"
#define kTitle @"Settings"
#define kLabelTag 999
#define kTableBG @"bg_tableView.png"

@interface KSSettingsController ()

@end

@implementation KSSettingsController {
    NSMutableArray *jsonResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    NSString *connectionText = @"Working Offline ....." ;
    if ([KSInternetManager isConnectionAvailable]) {
        connectionText = @"Working Online...." ;
    }

    NSArray *contactInfo = [[NSArray alloc]initWithObjects:@"Login",@"Contact us", nil];
    NSArray *appSettings = [[NSArray alloc]initWithObjects:@"Display badges", nil];
    NSArray *connectivity = [[NSArray alloc]initWithObjects:connectionText, nil];
    settingsDict = [[NSDictionary alloc]initWithObjectsAndKeys:
            contactInfo,@"Contact Information",
                    appSettings,@"Application Settings",
                    connectivity,@"Connectivity",
                    nil];
    settingsTable.scrollEnabled = NO;
}

- (void)decorateView{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kTableBG]];
    UISwitch *onOff = [[UISwitch alloc] initWithFrame: CGRectMake(220,192,50,40)];
    [onOff addTarget: self action: @selector(switchBadgeDisplay:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview: onOff];
    if(app.setBadge == YES)
        [onOff setOn:YES];
    else
        [onOff setOn:NO];
    settingsTable.backgroundColor = [UIColor clearColor];
}

-(void) switchBadgeDisplay:(UISwitch *)sender {
    if(sender.on){
        app.setBadge = YES;
    }
    else {
        app.setBadge = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.topItem.title  = @"Settings";
    [self decorateView];
    [settingsTable reloadData];
}


#pragma mark- sections and titles

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
//    return [settingsDict count];
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Contact Information" ;
        case 1:
            return @"Application Settings";
        case 2:
            return @"Connectivity";
    }
}


#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    switch (section)  {
        case 0:
            return [[settingsDict objectForKey:@"Contact Information"]count];
        case 1:
            return [[settingsDict objectForKey:@"Application Settings"] count];
        case 2:
            return [[settingsDict objectForKey:@"Connectivity"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        UILabel *txtLbl = (UILabel *)[cell.contentView viewWithTag:kLabelTag];
        [txtLbl removeFromSuperview];
    }
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,8,320,32)];
    textLabel.font = [UIFont systemFontOfSize:18.0];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = UITextAlignmentLeft;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.tag = kLabelTag;
    [cell.contentView addSubview:textLabel];

    switch (indexPath.section) {
        case 0:
            textLabel.text = [[settingsDict objectForKey:@"Contact Information"] objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            textLabel.text = [[settingsDict objectForKey:@"Application Settings"] objectAtIndex:indexPath.row];
            break;
        case 2:
            textLabel.text = [[settingsDict objectForKey:@"Connectivity"] objectAtIndex:indexPath.row];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    KSSettingsDetail *settingsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsDetail"];
    if(indexPath.row == 0 && indexPath.section == 0)
        settingsVc.urlString = @"http://www.cnapp.co.uk/admin/mobileWeb/signIn.html";
    else if(indexPath.row == 1 && indexPath.section == 0)
        settingsVc.urlString = @"http://www.cnapp.co.uk/admin/mobileWeb/contactUs.html";
    
    [self.navigationController pushViewController:settingsVc  animated: YES];
}

#pragma mark - memory
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
