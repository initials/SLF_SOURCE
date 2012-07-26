//
//  BCAchievementNotificationView.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "BCAchievementNotificationView.h"

@implementation BCAchievementNotificationView

@synthesize achievementDescription;
@synthesize backgroundView;
@synthesize detailLabel;
@synthesize iconView;
@synthesize textLabel;

#pragma mark -

- (id)initWithFrame:(CGRect)aFrame achievementDescription:(GKAchievementDescription *)anAchievement
{
	if ((self = [self initWithFrame:aFrame]))
	{
		self.achievementDescription = anAchievement;
	}
	return self;
}

- (id)initWithFrame:(CGRect)aFrame title:(NSString *)aTitle message:(NSString *)aMessage
{
    if ((self = [self initWithFrame:aFrame]))
    {
		self.textLabel.text = aTitle;
		self.detailLabel.text = aMessage;
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if ((self = [super initWithFrame:aFrame]))
    {
        // create the GK background
        UIImageView *tBackground = [[UIImageView alloc] initWithFrame:aFrame];
        tBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //tBackground.image = backgroundStretch;
        self.backgroundView = tBackground;
        self.opaque = NO;
        [tBackground release];
        [self addSubview:self.backgroundView];

        CGRect r1 = kBCAchievementText1;
        CGRect r2 = kBCAchievementText2;

        // create the text label
		textLabel = [[UILabel alloc] initWithFrame:r1];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        textLabel.text = NSLocalizedString(@"Achievement Unlocked", @"Achievemnt Unlocked Message");

        // detail label
        detailLabel = [[UILabel alloc] initWithFrame:r2];
        detailLabel.textAlignment = UITextAlignmentCenter;
        detailLabel.adjustsFontSizeToFitWidth = YES;
        detailLabel.minimumFontSize = 10.0f;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];

        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)dealloc
{
    [achievementDescription release];
    [backgroundView release];
    [detailLabel release];
    [iconView release];
    [textLabel release];
    
    [super dealloc];
}

- (void)setAchievementDescription:(GKAchievementDescription *)description
{
	[description retain];
	[achievementDescription release];
	achievementDescription = description;
	
	self.textLabel.text = self.achievementDescription.title;
	self.detailLabel.text = self.achievementDescription.achievedDescription;
	if(self.achievementDescription.image)
	{
		[self setImage:self.achievementDescription.image];
	}
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        if (!self.iconView)
        {
            iconView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 6.0f, 34.0f, 34.0f)];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.iconView];
        }
        self.iconView.image = image;
        self.textLabel.frame = kBCAchievementText1WLogo;
        self.detailLabel.frame = kBCAchievementText2WLogo;
    }
    else
    {
        if (self.iconView)
        {
            [self.iconView removeFromSuperview];
        }
        self.textLabel.frame = kBCAchievementText1;
        self.detailLabel.frame = kBCAchievementText2;
    }
}

@end
