//  Copyright Initials 2011. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// www.initialscommand.com

#import <Flixel/FlxObject.h>

@interface FlxSpriteOnPath : FlxManagedSprite
{
    float limitX;
    float limitY;
    
    float _pathSpeed;
    
    int _movementType;
    
    float _currentPathSpeed;
    
    BOOL _isAnimated;
    
}
+ (id) flxSpriteOnPathWithOrigin:(CGPoint)Origin withSpeed:(float)Speed withLimits:(CGPoint)Limits withMovementType:(int)MovementType isAnimated:(BOOL)animated;
- (id) initWithOrigin:(CGPoint)Origin withSpeed:(float)Speed  withLimits:(CGPoint)Limits withMovementType:(int)MovementType isAnimated:(BOOL)animated;

@property float limitX;
@property float limitY;

@property float _pathSpeed;

@property int _movementType;
@property float _currentPathSpeed;
@property BOOL _isAnimated;


@end