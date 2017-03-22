//
//  AppDelegate.h
//  Outlook Calendar
//
//  Created by Ahmed Sabry on 2/24/17.
//  Copyright © 2017 Sabry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

