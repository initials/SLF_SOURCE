//
//  BCAchievementViewProtocol.h
//  Aki
//
//  Created by Jeremy Knope on 10/26/10.
//  Copyright 2010 Buttered Cat Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@protocol BCAchievementViewProtocol

/**
 * Creates a new view with information from given achievement description
 * @param aFrame frame for the view
 * @param anAchievement Achievement description to use to fill out the view
 */
- (id)initWithFrame:(CGRect)aFrame achievementDescription:(GKAchievementDescription *)anAchievement;

/**
 * Creates a new achievement view with manually specified title & message
 * @param aFrame frame for the view
 * @param aTitle title for notification
 * @param aMessage long description/message for notification
 */
- (id)initWithFrame:(CGRect)aFrame title:(NSString *)aTitle message:(NSString *)aMessage;

/**
 * Background view, usually an image view showing a stretched background image
 */
- (UIView *)backgroundView;
- (void)setBackgroundView:(UIView *)aBackgroundView;

/**
 * Text label for the title of notification, you can set it manually by setting text on the label
 */
- (UILabel *)textLabel;

/**
 * Detail label for the message text of a achievenment notification.  You can set the text manually via this label.
 */
- (UILabel *)detailLabel;

/**
 * Image view that contains the achievement icon image, you can set the image manually via this view.
 */
- (UIImageView *)iconView;

/**
 * Sets the image, typically the achievement icon
 */
- (void)setImage:(UIImage *)image;
@end
