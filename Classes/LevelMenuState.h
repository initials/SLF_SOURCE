/*
 * Copyright (c) 2011-2012 Initials Video Games
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

@class Badge;
@class TalkBadge;

@interface LevelMenuState : FlxState
{
    FlxText * heading;
    FlxText * largeHCText;
    
    Badge * star1;
    Badge * star2;
    Badge * star3;
    Badge * star4;
    Badge * star5;
    Badge * star6;
    Badge * star7;
    Badge * star8;
    Badge * star9;
    Badge * star10;
    Badge * star11;
    Badge * star12;

    Badge * starhc1;
    Badge * starhc2;
    Badge * starhc3;
    Badge * starhc4;
    Badge * starhc5;
    Badge * starhc6;
    Badge * starhc7;
    Badge * starhc8;
    Badge * starhc9;
    Badge * starhc10;
    Badge * starhc11;
    Badge * starhc12;
    
    FlxSprite * screenDarken;

    TalkBadge * talkedToAndre1;
    TalkBadge * talkedToAndre2;
    TalkBadge * talkedToAndre3;
    TalkBadge * talkedToAndre4;
    TalkBadge * talkedToAndre5;
    TalkBadge * talkedToAndre6;
    TalkBadge * talkedToAndre7;
    TalkBadge * talkedToAndre8;
    TalkBadge * talkedToAndre9;
    TalkBadge * talkedToAndre10;
    TalkBadge * talkedToAndre11;
    TalkBadge * talkedToAndre12;
    
    TalkBadge * talkedToPlain1;
    TalkBadge * talkedToPlain2;
    TalkBadge * talkedToPlain3;
    TalkBadge * talkedToPlain4;
    TalkBadge * talkedToPlain5;
    TalkBadge * talkedToPlain6;
    TalkBadge * talkedToPlain7;
    TalkBadge * talkedToPlain8;
    TalkBadge * talkedToPlain9;
    TalkBadge * talkedToPlain10;
    TalkBadge * talkedToPlain11;
    TalkBadge * talkedToPlain12;
    
    TalkBadge * talkedToAndreHC1;
    TalkBadge * talkedToAndreHC2;
    TalkBadge * talkedToAndreHC3;
    TalkBadge * talkedToAndreHC4;
    TalkBadge * talkedToAndreHC5;
    TalkBadge * talkedToAndreHC6;
    TalkBadge * talkedToAndreHC7;
    TalkBadge * talkedToAndreHC8;
    TalkBadge * talkedToAndreHC9;
    TalkBadge * talkedToAndreHC10;
    TalkBadge * talkedToAndreHC11;
    TalkBadge * talkedToAndreHC12;
    
    TalkBadge * talkedToPlainHC1;
    TalkBadge * talkedToPlainHC2;
    TalkBadge * talkedToPlainHC3;
    TalkBadge * talkedToPlainHC4;
    TalkBadge * talkedToPlainHC5;
    TalkBadge * talkedToPlainHC6;
    TalkBadge * talkedToPlainHC7;
    TalkBadge * talkedToPlainHC8;
    TalkBadge * talkedToPlainHC9;
    TalkBadge * talkedToPlainHC10;
    TalkBadge * talkedToPlainHC11;
    TalkBadge * talkedToPlainHC12;
    
    
    FlxButton * l1Btn;
    FlxButton * l2Btn;
    FlxButton * l3Btn;
    FlxButton * l4Btn;
    FlxButton * l5Btn;
    FlxButton * l6Btn;
    FlxButton * l7Btn;
    FlxButton * l8Btn;
    FlxButton * l9Btn;
    FlxButton * l10Btn;
    FlxButton * l11Btn;
    FlxButton * l12Btn;

    FlxButton * lockedGraphic2Btn;
    FlxButton * lockedGraphic3Btn;
    FlxButton * lockedGraphic4Btn;
    FlxButton * lockedGraphic5Btn;
    FlxButton * lockedGraphic6Btn;
    FlxButton * lockedGraphic7Btn;
    FlxButton * lockedGraphic8Btn;
    FlxButton * lockedGraphic9Btn;
    FlxButton * lockedGraphic10Btn;
    FlxButton * lockedGraphic11Btn;
    FlxButton * lockedGraphic12Btn;
    
    FlxButton * l1BtnHC;
    FlxButton * l2BtnHC;
    FlxButton * l3BtnHC;
    FlxButton * l4BtnHC;
    FlxButton * l5BtnHC;
    FlxButton * l6BtnHC;
    FlxButton * l7BtnHC;
    FlxButton * l8BtnHC;
    FlxButton * l9BtnHC;
    FlxButton * l10BtnHC;
    FlxButton * l11BtnHC;
    FlxButton * l12BtnHC;
    
    FlxButton * lockedGraphic2BtnHC;
    FlxButton * lockedGraphic3BtnHC;
    FlxButton * lockedGraphic4BtnHC;
    FlxButton * lockedGraphic5BtnHC;
    FlxButton * lockedGraphic6BtnHC;
    FlxButton * lockedGraphic7BtnHC;
    FlxButton * lockedGraphic8BtnHC;
    FlxButton * lockedGraphic9BtnHC;
    FlxButton * lockedGraphic10BtnHC;
    FlxButton * lockedGraphic11BtnHC;
    FlxButton * lockedGraphic12BtnHC;
    FlxButton * backBtn;
}

- (void) addStars ;
- (void) addBottleCapBadges ;
- (void) arrangeBottleCapBadges ;

- (void) addTalkedToIcons ;
- (void) arrangeTalkedToIcons;
- (void) arrangeTalkedToIconsHC;

- (void) addHCTalkedToIcons ;

- (void) onHC ;
- (void) startAsHardCoreMode;
- (void) setAllButtonsToNotSelected;


@end

