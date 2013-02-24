//
//  CCUIViewWrapper+VoiceOver.m
//  ECHO
//
//  Created by Alexander Damhuis 25/12/2012.
//  Questions to ad[at]iphonedation.com please
//
//  This is free code under MIT License, created in Germany
#import "CCUIViewWrapper.h"
#import "CCUIViewWrapper+VoiceOver.h"

@implementation CCUIViewWrapper (VoiceOver)

+ (id) wrapperForUIView:(UIView*)ui withVoiceOverIsRunningNotification:(BOOL)useNotification {
    
    return [[self alloc] initForUIView:ui withVoiceOverIsRunningNotification:useNotification];
    
}

- (id) initForUIView:(UIView*)ui withVoiceOverIsRunningNotification:(BOOL)useNotification {
    
    if((self = [self init]))
	{
		self.uiItem = ui;
        
        if (useNotification) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(voiceOverStatusChanged)
                                                         name:UIAccessibilityVoiceOverStatusChanged
                                                       object:nil];
            
        }
        
       // self.visible = UIAccessibilityIsVoiceOverRunning();
       // self.uiItem.hidden = !self.visible;
        
		return self;
	}
	return nil;
    
}



-(void)dealloc {
    //CCLOG(@"CCUIViewWrapper Dealloc in %@ from parent %@", self, parent_);
    [uiItem removeFromSuperview];
    self.uiItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)voiceOverStatusChanged {
    
    //CCLOG(@"VoiceOverStatus has changed from %@", self);
    self.visible = UIAccessibilityIsVoiceOverRunning();
    
    
    
}


@end
