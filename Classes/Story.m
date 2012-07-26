#import "Story.h"



@implementation Story

@synthesize story;

+ (id) storyWithOrigin:(CGPoint)Origin index:(int)Index
{
	return [[[self alloc] initWithOrigin:Origin index:Index] autorelease];
}

- (id) initWithOrigin:(CGPoint)Origin index:(int)Index
{
	if ((self = [super initWithX:Origin.x y:Origin.y graphic:nil])) {
        story = [[NSArray alloc] initWithObjects:
                       [NSMutableArray arrayWithObjects:@"November 10, 1961.\nNews from military sources is that army forces have been mobilized and plan to invade the surronding city.",@" ",@" ", @"notepad", nil],
                       [NSMutableArray arrayWithObjects:@"Every month the same old news. Since WWII ended, every month more scare tactics.\nI run a business, my interest lies with feeding my family, not war.",@"player",@"army", @"", nil],                   
                       [NSMutableArray arrayWithObjects:@"The efforts of industry are not without casualties.\nAnd yet we work, and we work hard. Are we not entitled to that which we produce.",@"worker",@"player", @"",nil],                   
                       [NSMutableArray arrayWithObjects:@"\nYou are paid and paid well.",@"player",@"worker", @"",nil], 
                       [NSMutableArray arrayWithObjects:@"Liselot, my sweet emerald.\nI give you  my heart, my word and my life.\nI will work for our family so that they can have a good life.",@"player",@"liselot", @"0",nil], 
                       [NSMutableArray arrayWithObjects:@"\nFamily is all.",@"player",@"liselot", @"",nil],                   
                       [NSMutableArray arrayWithObjects:@"The government is blaming the Super Lemonade Factory for all the broken glass on the road.\nCan't anyone take some responsibility for themselves.",@"player",@"army", @"",nil],                   
                       [NSMutableArray arrayWithObjects:@"We run a tight ship. I learned that from my time in the Customs Office.\nWithout solid rules, everything runs foul.\nMy workers repsect this. They follow my rules.",@"player",@"worker", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"We keep it clean here. That food inspector is such a idiot!\n\nWe keep it clean, he should leave us alone.",@"player",@"inspector", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"The same people that create the street signs are the ones destroying and stealing them.\nCorruption is rife here!",@"player",@"army", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"Utilitarianism promises the greatest \"good\" for the greatest number...\nIf someone else falls between the cracks, it’s not your problem.",@"inspector",@"chef", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"If I am using my wealth to exceed\ngreater odds for my family’s happiness, I don’t see that\nas any more amoral as buying insurance.",@"player",@"0", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"I trust that people are beings with good intentions,\nbut you can’t expect to harvest a crop in a sewer.",@"player",@"0", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"The tragedy is not in the recognition of your fate,\nbut the weight that rests on your shoulders when no one is there to help you.",@"player",@"0", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"Trust, faith and common good.\nAll of them are masks painted to hide corruption.",@"player",@"0", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"\nTalk is cheap.",@"chef",@"0", @"0",nil],                                     
                       [NSMutableArray arrayWithObjects:@"\nI just heard Don't Fence Me In on the wireless. Fantastic song!",@"player",@"0", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"Our sons will run this factory one day.\nAnd their sons.\nAnd their son's sons.",@"player",@"liselot", @"0",nil],                                  
                       [NSMutableArray arrayWithObjects:@"During the war (World War II, 1942-1945), I tried to explain to my younger sisters what chocolate is. Can you imagine, trying to describe it.",@"liselot",@"player", @"0",nil],                                  
                       [NSMutableArray arrayWithObjects:@"I will turn over every corner of this so called Super Lemonade Factory until I find some dirt.",@"inspector",@"player", @"0",nil],
                       [NSMutableArray arrayWithObjects:@"A military contract to supply soda to the military landed on my desk today. Choosing sides in the turbulent time is risky, but the rewards are great.",@"player",@"army", @"0",nil],                   
                       [NSMutableArray arrayWithObjects:@"And so he had no sleep that night. The army was not strong arming him, they couldn't care. If he said no, they'd take their business elsewhere. Their big, lucrative business.",@"",@"", @"notepad",nil],
                       [NSMutableArray arrayWithObjects:@"For my family, I signed the papers.",@"player",@"army", @"",nil],
                       [NSMutableArray arrayWithObjects:@"Although now guaranteed a steady cash flow, still he did not sleep well. He was now a military contractor, and agreed to accept all that it entails.",@"",@"", @"notepad",nil],
                       [NSMutableArray arrayWithObjects:@"No need for an inspection today. You're with us now.",@"inspector",@"player", @"",nil],                  
                       [NSMutableArray arrayWithObjects:@"With the contracts in place my job is done. You'd imagine that I'd be content with my achievements. But I am a man apart. Society does not approve of men of my persuasion.",@"army",@"", @"",nil],                   
                       [NSMutableArray arrayWithObjects:@"\nI am off to my meeting with the Govenor General.",@"player",@"", @"",nil],                    
                       [NSMutableArray arrayWithObjects:@"Sometimes I feel the information I hand over to the army is more valuable than they give credit for. I am responsible for airing the community's thoughts and grievences. Do they care?",@"player",@"", @"",nil],                    
                       [NSMutableArray arrayWithObjects:@"We care.\nTrust us.\nWe are in total control.",@"army",@"player", @"",nil],                    
                       [NSMutableArray arrayWithObjects:@"\nThe End.",@"player",@"", @"",nil],                    
                       
                       nil];
        
        
	}
	
	return self;	
}

- (void) dealloc
{
	
	[super dealloc];
}


- (void) update
{     
    
    
	[super update];
	
}


@end
