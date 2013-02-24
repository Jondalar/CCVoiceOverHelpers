//
//  CCUIViewFromCCNodeWithVoiceOver.h
//  ECHO
//
//  Created by Alexander Damhuis 25/12/2012.
//  Questions to ad[at]iphonedation.com please
//
//  This is free code under MIT License, created in Germany 

#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCVOHelper : UIView

{
    
    CGSize screenSize;
    
}

+(CCVOHelper *) sharedCCVOHelper;
+(void) end;

- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverLabel:(NSString*)voLabel sender:(id)sender;
- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverButton:(NSString *)voButtonLabel sender:(id)sender selector:(SEL)selector;

- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverLabel:(NSString*)voLabel sender:(id)sender withCustomRect:(CGRect)customRect;
- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverButton:(NSString *)voButtonLabel sender:(id)sender selector:(SEL)selector withCustomRect:(CGRect)customRect;



@end
