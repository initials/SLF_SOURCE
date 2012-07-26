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

@class EnemyArmy;
@class EnemyChef;

@class EnemyInspector;
@class EnemyWorker;
@class Enemy;
@class EnemyGeneric;

@interface StatsState : FlxState
{
	
	FlxButton * back;
    FlxText * aboutText;
    
    //EnemyArmy * gb;
    EnemyGeneric * gb;
    EnemyGeneric * gs;
    EnemyGeneric * rb;
    EnemyGeneric * rs;
    
    FlxText * gbt2;
    FlxText * gst2;
    FlxText * rbt2;
    FlxText * rst2;
    
    BOOL upperPart;
    
    
    //achievements
    FlxText * achx1;
    FlxText * achx2;
    FlxText * achx3;
    FlxText * achx4;
    FlxText * achx5;
    FlxText * achx6;
    FlxText * achx7;
    FlxText * achx8;
    FlxText * achx9;
    
    FlxText * achx10;
    FlxText * achx11;
    FlxText * achx12;
    FlxText * achx13;
    FlxText * achx14;
    FlxText * achx15;
    FlxText * achx16;
    FlxText * achx17;
    FlxText * achx18;

    FlxText * achx19;
    FlxText * achx20;    
    

    

}

@end

