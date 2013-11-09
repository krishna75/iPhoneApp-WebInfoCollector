//
//  AppDelegate.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#define app ((AppDelegate*) [[UIApplication sharedApplication] delegate])
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIView *loadingView;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL setBadge;

-(void)RemoveLoadingView;
-(void)AddloadingView ;

@end
