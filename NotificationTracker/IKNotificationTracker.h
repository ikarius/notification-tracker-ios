//
//  IKNotificationTracker.h
//  NotificationTracker
//
//  Created by Frédéric VERGEZ on 13/02/14.
//  Copyright (c) 2014 ikarius. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simple convenience notification logger/tracker.
 *
 * You can add manually new notification names with the +trackNotification: method
 * OR
 * create an entry in the bundle dictionary under the key 'NotificationTrackerFile' 
 * containing the name of a plist configuration file (without .plist extension).
 *
 * This file must contain a single array of notification keys/name.
 *
 * Feel free to replace NSLog() by the logger of your choice.
 *
 * Initialize once with the +start method.
 */
@interface IKNotificationTracker : NSObject

/**
 * Start logging notification content.
 */
+ (void)start;

/**
 * Flush the current pool of tracked notifications.
 * Reload config file, if any.
 */
+ (void)reset;

/**
 * Adds a new notification (name) to track.
 * @param notificationName: Name/key of the notification.
 */
+ (void)addNotification:(NSString*)notificationName;

/**
 * Removes a notification name from the tracking pool.
 * @param notificationName: Name/key of the notification.
 */
+ (void)removeNotification:(NSString*)notificationName;

@end

// Config key for bundle plist info file.
extern NSString* const kNotificationLoggerConfigFileKey;
