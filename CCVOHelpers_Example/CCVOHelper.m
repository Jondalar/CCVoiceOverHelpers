//
//  CCUIViewFromCCNodeWithVoiceOver.m
//  ECHO
//
//  Created by Alexander Damhuis 25/12/2012.
//  Questions to ad[at]iphonedation.com please
//
//  This is free code under MIT License, created in Germany
#import "cocos2d.h"
#import "CCVOHelper.h"
//define VoiceOver language, this is the voice the system uses to read.
//here you can localize
//For now we use this

#define kVOLanguage @"en-EN"


#

@implementation CCVOHelper : UIView

static CCVOHelper* ccVOHelper = nil;

+(CCVOHelper *)sharedCCVOHelper {
    
   
        @synchronized(self)     {
            if (!ccVOHelper)
                ccVOHelper = [[CCVOHelper alloc] init];
        }
        return ccVOHelper;
}

+(void) end
{
	ccVOHelper = nil;
    
}



- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverLabel:(NSString*)voLabel sender:(id)sender {
    
    
        //CCLOG(@"UI Label init in %@ with no CustomRect", self);
        
        return [self createUIViewItemFromCCNode:ccnode
                           withVoiceOverLabel:voLabel
                                       sender:sender
                               withCustomRect:[self getRectfromCCNode:ccnode]];
        
    
}


- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverButton:(NSString *)voButtonLabel sender:(id)sender selector:(SEL)selector {
    
    
    
        //CCLOG(@"VoiceOverButton init in %@ with no CustomRect", self);

        return [self createUIViewItemFromCCNode:ccnode
                          withVoiceOverButton:voButtonLabel
                                       sender:sender
                                     selector:selector
                               withCustomRect:[self getRectfromCCNode:ccnode]];
        
}

- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverLabel:(NSString*)voLabel sender:(id)sender withCustomRect:(CGRect)customRect
{
    
    
                
        //CCLOG(@"CCUIViewFromCCNode called, self = %@, CCNode = %@, senderObject = %@", self, ccnode, sender);
        
        UILabel * voiceOverTextLabel = [[UILabel alloc] initWithFrame:[self convertToRetinaRect:customRect]];
        [voiceOverTextLabel setText:voLabel];
        [voiceOverTextLabel setLineBreakMode:UILineBreakModeWordWrap];
        [voiceOverTextLabel setNumberOfLines:0];
        [voiceOverTextLabel setTextColor: [UIColor redColor]];
        [voiceOverTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
        [voiceOverTextLabel setTextAlignment:NSTextAlignmentCenter];
        [voiceOverTextLabel setAccessibilityLanguage:kVOLanguage];

        [voiceOverTextLabel setAccessibilityTraits:UIAccessibilityTraitStaticText];

        //CCLOG(@"UILabel = %@", voiceOverTextLabel);
            
        return (id)voiceOverTextLabel;
}


- (UIView*)createUIViewItemFromCCNode:(id)ccnode withVoiceOverButton:(NSString *)voButtonLabel sender:(id)sender selector:(SEL)selector withCustomRect:(CGRect)customRect {
        
        //CCLOG(@"CCUIViewFromCCNode called, self = %@, CCNode = %@, senderObject = %@", self, ccnode, sender);
        
        UIButton* voiceOverButton = [UIButton buttonWithType:UIButtonTypeCustom];   // this needs to be Custom to be transparent and still touchable
        voiceOverButton.frame = [self convertToRetinaRect:customRect];
        [voiceOverButton setAccessibilityLanguage:kVOLanguage];                        // overwrites the system default
        [voiceOverButton setAccessibilityLabel:voButtonLabel];
        [voiceOverButton addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];
            
        //CCLOG(@"UIButton = %@", voiceOverButton);
            
        return (id)voiceOverButton;

}

-(CGRect)getRectfromCCNode:(CCNode*)ccnode {
    
    CCNode* _ccnode = ccnode;
    
    return CGRectMake((_ccnode.position.x), (ccnode.position.y), (_ccnode.contentSize.width) ,(_ccnode.contentSize.height));
}

-(CGRect)convertToRetinaRect:(CGRect)rect {
    
    
    screenSize = [[CCDirector sharedDirector] winSize];
    
    float _scaleFactor = 1.0f;
    if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        //CCLOG(@"Device is Retinarunning, so devide all by 2");
        _scaleFactor = 1.0f; // prep'd if we need to scale between UIView and CCNode, I am not clear yet
    }
    
    CGRect outputRect = CGRectMake(rect.origin.x * _scaleFactor,
                                  (screenSize.height - rect.origin.y) * _scaleFactor,
                                  rect.size.width * _scaleFactor,
                                  rect.size.height * _scaleFactor);
    
    //CCLOG(@"Outputrect:\nposition.x: %f\nposition.y: %f\nsize.width: %f\nsize.height: %f", outputRect.origin.x, outputRect.origin.y, outputRect.size.width, outputRect.size.height);
    return outputRect;
}

@end
