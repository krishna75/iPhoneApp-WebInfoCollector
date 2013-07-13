//
//  settingsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 21/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "settingsController.h"
#import "KSJson.h"
#import "SettingsDetail.h"
#import "AppDelegate.h"


#define kjsonURL @"events.php"
#define kTitle @"Settings"
#define kLabelTag 999
#define kTableBG @"bg_tableView.png"

@interface settingsController ()

@end

@implementation settingsController {
    NSMutableArray *jsonResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    NSArray *contactInfo = [[NSArray alloc]initWithObjects:@"Login",@"Contact us", nil];
    NSArray *appSettings = [[NSArray alloc]initWithObjects:@"Display badges", nil];
    settingsDict = [[NSDictionary alloc]initWithObjectsAndKeys:contactInfo,@"Contact Information",appSettings,@"Application Settings", nil];
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
    
    self.navigationController.navigationBar.topItem.title  = kTitle;
    [self decorateView];
    [settingsTable reloadData];
}


#pragma mark- sections and titles

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return [settingsDict count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    if(section == 0)
        return @"Contact Information";
    else
        return @"Application Settings";
}


#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if(section == 0)
        return [[settingsDict objectForKey:@"Contact Information"]count];
    else
        return [[settingsDict objectForKey:@"Application Settings"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
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
    if(indexPath.section == 0) {
        textLabel.text = [[settingsDict objectForKey:@"Contact Information"] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
        textLabel.text = [[settingsDict objectForKey:@"Application Settings"] objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    SettingsDetail *settingsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsDetail"];
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
