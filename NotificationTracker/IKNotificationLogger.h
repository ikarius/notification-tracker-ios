//
//  IKNotificationLogger.h
//  NotificationTracker
//
//  Created by Frédéric VERGEZ on 13/02/14.
//  Copyright (c) 2014 ikarius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKNotificationLogger : NSObject

+ (instancetype)sharedInstance;

+ (void)trackNotification:(NSString*)notificationName;

+ (void)reset;

@end
