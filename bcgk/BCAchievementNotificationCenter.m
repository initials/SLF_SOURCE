//
//  BCAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BCAchievementNotificationCenter.h"
#import "BCAchievementNotificationView.h"

#define kBCAchievementDefaultSize   CGSizeMake(284.0f, 52.0f)
#define kBCAchievementViewPadding	20.0f
#define kBCAchievementAnimeTime     0.4f
#define kBCAchievementDisplayTime   2.30f

//static BCAchievementNotificationCenter *defaultHandler = nil;

#pragma mark -

@interface BCAchievementNotificationCenter(private)

- (void)displayNotification:(UIView<BCAchievementViewProtocol> *)notification;
- (void)animateOut:(NSTimer *)timer;
- (void)orientationChanged:(NSNotification *)notification;
- (CGRect)startFrameForFrame:(CGRect)aFrame;
- (CGRect)endFrameForFrame:(CGRect)aFrame;
- (UIInterfaceOrientation)interfaceOrientation;
- (void)setupDefaultFrame;
@end

#pragma mark -

@implementation BCAchievementNotificationCenter(private)

- (void)displayNotification:(UIView<BCAchievementViewProtocol> *)notification
{
	if(!_containerWindow)
	{
		CGRect containerFrame = [[UIScreen mainScreen] bounds];
		UIInterfaceOrientation o = [self interfaceOrientation];
		if(UIInterfaceOrientationIsLandscape(o))
			containerFrame.size = CGSizeMake(containerFrame.size.height, containerFrame.size.width);
		_containerWindow = [[UIWindow alloc] initWithFrame:containerFrame];
		_containerWindow.windowLevel = UIWindowLevelStatusBar;
		_containerWindow.userInteractionEnabled = NO;
		[self setupDefaultFrame];
	}
	
	notification.frame = [self startFrameForFrame:notification.frame];
	[_containerWindow addSubview:notification];
	_containerWindow.hidden = NO;
//	_containerWindow.frame = CGRectMake(50, 50, 100, 100);
	//[notification animateIn];
	// TODO: i think handler should handle animations, don't think it's the view's job to
	currentNotification = notification;
	[UIView animateWithDuration:kBCAchievementAnimeTime delay:0.0 options:0 
					 animations:^{
						 animating = YES;
						 notification.frame = [self endFrameForFrame:notification.frame];
					 } 
					 completion:^(BOOL finished) {
						 animating = NO;
						 delayTimer = [[NSTimer scheduledTimerWithTimeInterval:kBCAchievementDisplayTime target:self selector:@selector(animateOut:) userInfo:nil repeats:NO] retain];
					 }];
}

- (void)animateOut:(NSTimer *)timer
{
	animating = YES;
	[delayTimer invalidate];
	[delayTimer release];
	delayTimer = nil;
	[UIView animateWithDuration:kBCAchievementAnimeTime delay:0.0 options:0 
					 animations:^{
						 currentNotification.frame = [self startFrameForFrame:currentNotification.frame];
					 } 
					 completion:^(BOOL finished) {
						 animating = NO;
						 [currentNotification removeFromSuperview];
						 currentNotification = nil;
						 [_queue removeObjectAtIndex:0];
						 if ([_queue count])
						 {
							 [self displayNotification:(UIView<BCAchievementViewProtocol> *)[_queue objectAtIndex:0]];
						 }
						 else
							 _containerWindow.hidden = YES;
//						 [notification removeFromSuperview];
					 }];
}

- (CGRect)rectForRect:(CGRect)rect withinRect:(CGRect)bigRect withMode:(UIViewContentMode)mode
{
	CGRect result = rect;
	switch (mode)
	{
		case UIViewContentModeCenter:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		case UIViewContentModeBottom:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMaxY(bigRect) - (rect.size.height);
			break;
		case UIViewContentModeBottomLeft:			
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMaxY(bigRect) - rect.size.height;
			break;
		case UIViewContentModeBottomRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMaxY(bigRect) - rect.size.height;
			break;
		case UIViewContentModeLeft:
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		case UIViewContentModeTop:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeTopLeft:
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeTopRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		default:
			break;
	}
	return result;
}

// off screen
- (CGRect)startFrameForFrame:(CGRect)aFrame
{
	CGRect result = aFrame;
	CGRect containerRect = [[BCAchievementNotificationCenter defaultCenter] containerRect];
	result = [self rectForRect:result withinRect:containerRect withMode:self.viewDisplayMode];
	result = CGRectIntegral(result);
	switch (self.viewDisplayMode) {
		case UIViewContentModeTop:
		case UIViewContentModeTopLeft:
		case UIViewContentModeTopRight:
			result.origin.y -= (aFrame.size.height + kBCAchievementViewPadding);
			break;
		case UIViewContentModeBottom:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeBottomRight:
			result.origin.y += (aFrame.size.height + kBCAchievementViewPadding);
			break;
		case UIViewContentModeLeft:
			result.origin.x -= aFrame.size.width;
			break;
		case UIViewContentModeRight:
			result.origin.x += aFrame.size.width;
			break;
		default:
			break;
	}
	// adjust for horizontal padding
	switch (self.viewDisplayMode) {
		case UIViewContentModeTopLeft:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeLeft:
			result.origin.x += kBCAchievementViewPadding;
			break;
		case UIViewContentModeTopRight:
		case UIViewContentModeBottomRight:
		case UIViewContentModeRight:
			result.origin.x -= kBCAchievementViewPadding;
			break;
		default:
			break;
	}
	return result;
}

// on screen
- (CGRect)endFrameForFrame:(CGRect)aFrame
{
	CGRect result = aFrame;
	CGRect containerRect = [[BCAchievementNotificationCenter defaultCenter] containerRect];
	result = [self rectForRect:result withinRect:containerRect withMode:self.viewDisplayMode];
	result = CGRectIntegral(result);
	switch (self.viewDisplayMode) {
		case UIViewContentModeTop:
		case UIViewContentModeTopLeft:
		case UIViewContentModeTopRight:
			result.origin.y += kBCAchievementViewPadding; // padding from top of screen
			break;
		case UIViewContentModeBottom:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeBottomRight:
			result.origin.y -= kBCAchievementViewPadding;
			break;
		default:
			break;
	}
	// adjust for horizontal padding
	switch (self.viewDisplayMode) {
		case UIViewContentModeTopLeft:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeLeft:
			result.origin.x += kBCAchievementViewPadding;
			break;
		case UIViewContentModeTopRight:
		case UIViewContentModeBottomRight:
		case UIViewContentModeRight:
			result.origin.x -= kBCAchievementViewPadding;
			break;
		default:
			break;
	}
	return result;
}

- (void)orientationChanged:(NSNotification *)notification
{
	UIInterfaceOrientation o = [self interfaceOrientation];
	
	// prevent calling orientation animation code excessively
	if(o == currentOrientation) {
		return;
	}
	currentOrientation = o;
	
	CGFloat angle = 0;
	switch (o) {
		case UIInterfaceOrientationLandscapeLeft: angle = -90; break;
		case UIInterfaceOrientationLandscapeRight: angle = 90; break;
		case UIInterfaceOrientationPortraitUpsideDown: angle = 180; break;
		default: break;
	}
	
	CGRect f = _containerWindow.frame;
	
	// Swap the frame height and width if necessary
 	if (UIDeviceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	
	CGAffineTransform previousTransform = _containerWindow.layer.affineTransform;
	CGAffineTransform newTransform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
	//newTransform = CGAffineTransformConcat(newTransform, CGAffineTransformMakeTranslation(f.size.height, 0));
	
	// Reset the transform so we can set the size
	_containerWindow.layer.affineTransform = CGAffineTransformIdentity;
	_containerWindow.frame = (CGRect){0,0,f.size};
	
	// Revert to the previous transform for correct animation
	_containerWindow.layer.affineTransform = previousTransform;
	
	// animate rotation & new notification location
	[UIView animateWithDuration:0.3 
					 animations:^(void) {
						// Set the new transform & new window frame
						_containerWindow.layer.affineTransform = newTransform;
						_containerWindow.frame = (CGRect){0,0,_containerWindow.frame.size};
						
						// fix notification location
						if(currentNotification && !animating) {
							currentNotification.frame = [self endFrameForFrame:currentNotification.frame];
						}
					 } 
					 completion:^(BOOL finished) {
					 }
	 ];
}

- (UIInterfaceOrientation)interfaceOrientation
{
	if([mainWindow rootViewController]) {
		return [[mainWindow rootViewController] interfaceOrientation];
	}
	return [[UIApplication sharedApplication] statusBarOrientation];
}

- (void)setupDefaultFrame
{
	UIInterfaceOrientation o = [self interfaceOrientation];
	
	CGFloat angle = 0;
	switch (o) {
		case UIInterfaceOrientationLandscapeLeft: angle = -90; break;
		case UIInterfaceOrientationLandscapeRight: angle = 90; break;
		case UIInterfaceOrientationPortraitUpsideDown: angle = 180; break;
		default: break;
	}
	
	CGRect f = _containerWindow.frame;
	
	// Swap the frame height and width if necessary
 	if (UIDeviceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	
	CGAffineTransform previousTransform = _containerWindow.layer.affineTransform;
	CGAffineTransform newTransform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
	
	// Reset the transform so we can set the size
	_containerWindow.layer.affineTransform = CGAffineTransformIdentity;
	_containerWindow.frame = (CGRect){0,0,f.size};
	
	// Revert to the previous transform for correct animation
	_containerWindow.layer.affineTransform = previousTransform;
	
	// Set the new transform
	_containerWindow.layer.affineTransform = newTransform;
	
	// Fix the view origin
	_containerWindow.frame = (CGRect){f.origin.x,f.origin.y,f.size.width, f.size.height};
//    [UIView commitAnimations];
}

@end

#pragma mark -

@implementation BCAchievementNotificationCenter

@synthesize mainWindow;
@synthesize image;
@synthesize defaultBackgroundImage;
@synthesize viewDisplayMode;
@synthesize defaultViewSize;
@synthesize viewClass;

#pragma mark -

+ (BCAchievementNotificationCenter *)defaultCenter
{
	static BCAchievementNotificationCenter *sharedInstance = nil;
    static dispatch_once_t pred;
	
    if (sharedInstance) return sharedInstance;
	
    dispatch_once(&pred, ^{
        sharedInstance = [[BCAchievementNotificationCenter alloc] init];
    });
	
    return sharedInstance;
}

- (id)init
{
	if ((self = [super init]))
	{
		self.mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0]; // TODO: check if it even has any?
		self.viewDisplayMode = UIViewContentModeTop;
		self.defaultViewSize = kBCAchievementDefaultSize;
		self.viewClass = [BCAchievementNotificationView class];
		currentOrientation = [self interfaceOrientation];
		
		[self setupDefaultFrame];
		
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
		self.defaultBackgroundImage = [[UIImage imageNamed:@"gk-notification.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f];
		
		if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
			[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
	[delayTimer invalidate];
	[delayTimer release];
	delayTimer = nil;
	[_containerWindow release];
    [_queue release];
    [image release];
    [super dealloc];
}

#pragma mark -

- (CGRect)containerRect
{
	UIInterfaceOrientation o = [self interfaceOrientation];
	
	CGRect f = [[UIScreen mainScreen] bounds];
	
	// Swap the frame height and width if necessary
 	if (UIInterfaceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	return f;
}

#pragma mark -

- (void)queueNotification:(BCAchievementNotificationView *)notification
{
	[_queue addObject:notification];
	if([_queue count] == 1)
		[self displayNotification:notification];
}

- (void)notifyWithAchievementDescription:(GKAchievementDescription *)achievement
{
	CGRect frame = CGRectMake(0, 0, self.defaultViewSize.width, self.defaultViewSize.height);
    UIView<BCAchievementViewProtocol> *notification = [[[viewClass alloc] initWithFrame:frame achievementDescription:achievement] autorelease];
	((UIImageView *)[notification backgroundView]).image = self.defaultBackgroundImage;

	[self queueNotification:notification];
}

- (void)notifyWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)anImage
{
	CGRect frame = CGRectMake(0, 0, self.defaultViewSize.width, self.defaultViewSize.height);
    UIView<BCAchievementViewProtocol> *notification = [[[viewClass alloc] initWithFrame:frame title:title message:message] autorelease];
	((UIImageView *)[notification backgroundView]).image = self.defaultBackgroundImage;
	if(anImage)
		[notification setImage:anImage];
	else if(self.image)
        [notification setImage:self.image];
    else
        [notification setImage:nil];
	
	[self queueNotification:notification];
}

@end
