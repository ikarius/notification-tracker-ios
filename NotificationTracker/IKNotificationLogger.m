//
//  IKNotificationLogger.m
//  NotificationTracker
//
//  Created by Frédéric VERGEZ on 13/02/14.
//  Copyright (c) 2014 ikarius. All rights reserved.
//

#import "IKNotificationLogger.h"

@implementation IKNotificationLogger

#pragma mark - Public API

static NSMutableSet *_notificationsFiltered = nil;

+ (instancetype)sharedInstance
{
    static IKNotificationLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] _init];
        _notificationsFiltered = [NSMutableSet new];
    });
    return sharedInstance;
}


+ (void)trackNotification:(NSString*)notificationName
{
    @synchronized(self)
    {
        if (_notificationsFiltered && notificationName)
        {
            [_notificationsFiltered addObject:notificationName];
        }
    }
}

+ (void)reset
{
    @synchronized(self)
    {
        if (_notificationsFiltered)
        {
            [_notificationsFiltered removeAllObjects];
        }
    }
}

#pragma mark - Init and internal callback

- (id)init
{
    @throw
    [NSException exceptionWithName:@"SharedInstanceException"
                            reason:@"Do not instanciate singleton object"
                          userInfo:nil];
}

- (id)_init
{
    self = [super init];
    
    if (self)
    {
        // Intercept and log notifications:
        CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),
                                        NULL,
                                        _SRFglobalNotificationCallback,
                                        NULL,
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
    }
    
    return self;
}

void _SRFglobalNotificationCallback (CFNotificationCenterRef center,
                                     void *observer,
                                     CFStringRef name,
                                     const void *object,
                                     CFDictionaryRef userInfo)
{
    if (_notificationsFiltered &&
        ([_notificationsFiltered containsObject:(__bridge id)(name)]
         || [_notificationsFiltered count] == 0) )
    {
        NSLog(@"Notification triggered: %@", name);
        
        if (userInfo)
        {
            NSLog(@"Notification 'userinfo': %@", userInfo);
        }
    }
}



@end
