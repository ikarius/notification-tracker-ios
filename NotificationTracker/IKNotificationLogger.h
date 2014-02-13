//
//  IKNotificationLogger.h
//  NotificationTracker
//
//  Created by Frédéric VERGEZ on 13/02/14.
//  Copyright (c) 2014 ikarius. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simple convenience notification logger.
 *
 * You can add manually new notification names with the +trackNotification: method
 * OR
 * create an entry in the bundle dictionary under the key '' containing the name of a plist
 * configuration file (without .plist extension).
 *
 * This file must contain a single array of notification keys/name.
 *
 * Feel free to replace NSLog by the logger of your choice.
 *
 * Initialize once with the +start method.
 */
@interface IKNotificationLogger : NSObject

/**
 * Start logging notification content.
 */
+ (void)start;

/**
 * Flush the current pool of tracked notifications.
 * Reload config file if any.
 */
+ (void)reset;

/**
 * Add a new notification (name) to track.
 * notificationName: Name/key of the notification.
 */
+ (void)trackNotification:(NSString*)notificationName;


@end
