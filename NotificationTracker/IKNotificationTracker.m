//
//  IKNotificationTracker.m
//  NotificationTracker
//
//  Created by Frédéric VERGEZ on 13/02/14.
//  Copyright (c) 2014 ikarius. All rights reserved.
//

#import "IKNotificationTracker.h"

@implementation IKNotificationTracker

#pragma mark - Public API

static NSMutableSet *_notificationsFiltered = nil;


+ (instancetype)_sharedInstance
{
    static IKNotificationTracker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _notificationsFiltered = [NSMutableSet new];
        sharedInstance = [[[self class] alloc] _init];
        
        NSLog(@"Now logging notifications");
    });
    
    return sharedInstance;
}


+ (void)start
{
    [IKNotificationTracker _sharedInstance];
}


+ (void)addNotification:(NSString*)notificationName
{
    NSAssert(notificationName, @"Invalid notification name");
    NSAssert(_notificationsFiltered, @"Notification pool is not ready");
    
    @synchronized(self)
    {
        [_notificationsFiltered addObject:notificationName];
    }
}

+ (void)removeNotification:(NSString*)notificationName
{
    NSAssert(notificationName, @"Invalid notification name");
    NSAssert(_notificationsFiltered, @"Notification pool is not ready");
    
    @synchronized(self)
    {
        [_notificationsFiltered removeObject:notificationName];
    }
}


+ (void)reset
{
    @synchronized(self)
    {
        if (_notificationsFiltered)
        {
            [_notificationsFiltered removeAllObjects];
            
            [[IKNotificationTracker _sharedInstance] _initFiltersFromPlistFile];
        }
    }
}

#pragma mark - Init and internal callback

NSString* const kNotificationLoggerConfigFileKey = @"NotificationTrackerFile";

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
        // Load from file if exists:
        [self _initFiltersFromPlistFile];
        
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


- (void)_initFiltersFromPlistFile
{
    // Check if a plist exist
    NSString* filename = [[[NSBundle bundleForClass:self.class] infoDictionary] valueForKey:kNotificationLoggerConfigFileKey];
    if (filename)
    {
        // TODO: loading mechanism
        NSString* path = [[NSBundle bundleForClass:self.class] pathForResource:filename ofType:@"plist"];
        if (path)
        {
            _notificationsFiltered = [[NSMutableSet alloc ] initWithArray:[NSArray arrayWithContentsOfFile:path]];
        }
        else
        {
            NSLog(@"Warning: Could not load file '%@.plist' from bundle", filename);
        }
    }
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