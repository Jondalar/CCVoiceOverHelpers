//
//  HelloWorldLayer.m
//  CCVOHelpers_Example
//
//  Created by Alexander Damhuis on 24.02.13.
//  Copyright iPhonedation 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

/*
 
 CCVOHelpers
 
 See Readme.md for details
 
 This is based on HelloWorld from COcos2d-iphone.
 
 Basically it allows to add a UIKit Element for CCNode. To create those objects a call to 
 the helper class is required, it will return the object and add it to a specified node.
 
 This is a side product I created based on CCUIViewWrapper for my game ECHO
 It will probably change over time, but here is the actual implementation I use in ECHO which is with THIS 
 in the AppStore.
 
*/


#import "CCUIViewWrapper+VoiceOver.h"
#import "CCVOHelper.h"

#define kVOTag 1975


#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        
        // ===========================
        // Convenience functionality:
        // if VO status changes while app is running
        // we get notified and hide/show the UIKit Elements we need
        // for 
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(voiceOverStatusChanged)
                                                     name:UIAccessibilityVoiceOverStatusChanged
                                                   object:nil];
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        
        // Add Textlabel which is transparent but will be read by UIAccessibility
        
		[self addUIViewLabelWithString:label.string
                             forCCNode:label
                              withRect:CGRectMake(label.position.x - (label.texture.contentSize.width / 2), //crappy Anchorpoint differences
                                                  label.position.y + (label.texture.contentSize.height /2), //I am sure this can be more elegant
                                                  label.texture.contentSize.width,
                                                  label.texture.contentSize.height)];
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
        
        //moving the Strings out, since I did  not find how to directly access the string of the CCMenuItemFont object
        // they way it is used in this example
        
        NSString* achievementString = @"Achievements";
        NSString* leaderboardString = @"Leaderboard";
        
        
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:achievementString block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
        
        
                                    
        
  		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:leaderboardString block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
        
        //padding value
        
        int padding = 20;
		
		[menu alignItemsHorizontallyWithPadding:padding];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        CCLOG(@"itemAchievement Rect start x: %f, start y: %f, size x: %f, size y: %f", itemAchievement.rect.origin.x, itemAchievement.rect.origin.y, itemAchievement.rect.size.width, itemAchievement.rect.size.height);
        
        // add UIButton with the activate method in this thing
        // the fact that this is labels inside a menu requires manual setting of the CGRect parameters
        // this could use some more work
        
        [self addUIViewButtonWithString:achievementString
                              forCCNode:itemAchievement
                             withTarget:itemAchievement
                           withSelector:@selector(activate) //this calls the activate method of the button, in this case the block above!
                               withRect:CGRectMake(size.width/2 - itemAchievement.rect.size.width,
                                                   size.height/2 - itemAchievement.rect.size.height,
                                                   itemAchievement.rect.size.width,
                                                   itemAchievement.rect.size.height) ];
        
        
        // Same here
        
        [self addUIViewButtonWithString:leaderboardString
                              forCCNode:itemLeaderboard
                             withTarget:itemLeaderboard
                           withSelector:@selector(activate)
                               withRect:CGRectMake(size.width/2 + padding,
                                                   size.height/2 - itemLeaderboard.rect.size.height,
                                                   itemLeaderboard.rect.size.width,
                                                   itemLeaderboard.rect.size.height) ];

        

        

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}


#pragma mark VoiceOver stuff

-(CCUIViewWrapper*)addUIViewButtonWithString:(NSString *)voString forCCNode:(CCNode*)ccnode withTarget:(id)target withSelector:(SEL)selector withRect:(CGRect)rect
{
    
    CCUIViewWrapper* voiceOverButtonWrapper = [CCUIViewWrapper wrapperForUIView:
                                               [[CCVOHelper sharedCCVOHelper] createUIViewItemFromCCNode:ccnode
                                                                                              withVoiceOverButton:voString
                                                                                                  sender:target
                                                                                                selector:selector
                                                                                          withCustomRect:rect]
                                             withVoiceOverIsRunningNotification:YES];
    [self addChild:voiceOverButtonWrapper z:10 tag:kVOTag];
    
    return voiceOverButtonWrapper;
    
}


-(CCUIViewWrapper*)addUIViewLabelWithString:(NSString *)voString forCCNode:(CCNode*)ccnode withRect:(CGRect)rect
{
    CCUIViewWrapper* voiceOverTextLabelWrapper = [CCUIViewWrapper wrapperForUIView:
                                                  [[CCVOHelper sharedCCVOHelper] createUIViewItemFromCCNode:ccnode
                                                                                         withVoiceOverLabel:voString
                                                                                                     sender:self
                                                                                             withCustomRect:rect]
                                                withVoiceOverIsRunningNotification:YES];
    voiceOverTextLabelWrapper.opacity = 1; //make it opaque, not 0, because than it is "hidden" for UIAccessibility
    [self addChild:voiceOverTextLabelWrapper z:10 tag:kVOTag];
    
    return voiceOverTextLabelWrapper;
    
}


//Callback methos for Notifier
//If you work with multiple scenes, this could also be done via a call back to the
// AppDelegate and a method that the delegate calls via asking CCDirector for actual running scene

-(void)voiceOverStatusChanged {
    
    CCLOG(@"User switched VoiceOver to %s", UIAccessibilityIsVoiceOverRunning() ? "ON" : "OFF");
    
}


@end