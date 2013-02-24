//
//  CCUIViewWrapper+VoiceOver.h
//  ECHO
//
//  Created by Alexander Damhuis 25/12/2012.
//  Questions to ad[at]iphonedation.com please
//
//  This is free code under MIT License, created in Germany 

#import "cocos2d.h"
#import "CCUIViewWrapper.h"

@interface CCUIViewWrapper (VoiceOver)


+ (id) wrapperForUIView:(UIView*)ui withVoiceOverIsRunningNotification:(BOOL)useNotification;

- (id) initForUIView:(UIView*)ui withVoiceOverIsRunningNotification:(BOOL)useNotification;


@end
