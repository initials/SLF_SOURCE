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

@interface NavArrow : FlxManagedSprite
{
    int maxValue;
    int currentValue;
    CGPoint loc1;
    CGPoint loc2;
    CGPoint loc3;
    CGPoint loc4;
    CGPoint loc5;
    CGPoint loc6;
    CGPoint loc7;
    CGPoint loc8;
    CGPoint loc9;
    CGPoint loc10;
    CGPoint loc11;
    CGPoint loc12;
    CGPoint loc13;
    CGPoint loc14;
    
}

+ (id) navArrowWithOrigin:(CGPoint)Origin ;
- (id) initWithOrigin:(CGPoint)Origin ;


@property int maxValue;
@property int currentValue;
@property CGPoint loc1;
@property CGPoint loc2;
@property CGPoint loc3;
@property CGPoint loc4;
@property CGPoint loc5;
@property CGPoint loc6;
@property CGPoint loc7;
@property CGPoint loc8;
@property CGPoint loc9;
@property CGPoint loc10;
@property CGPoint loc11;
@property CGPoint loc12;
@property CGPoint loc13;
@property CGPoint loc14;

@end
