CCVOHelper
===========

About: 

This is my self made set of classes/categories to add VoiceOver to CCLabels, CCSprites, CCMenuItems or basically any kind of CCNode to Cocos2d.
I came up with this when making ECHO - hear to play (www.echo-app.net). While the game itself uses postional audio and accelerometer as
Feedback and Input, there was no way for a visually impaired person to reach the gamelayer without navigating through some sort of menu at least.

Unfortunately Cocos2d is very detached from UIKit. Though every CCNode-inherited object does own the UIAccessibility properties (because they are inherited from NSObject I guess), there is no easy way to make the whole NOde-stuff work with UIAccessibility.

The system provides VoiceOver via this (UIAccessibility) and so I found CCUIViewWrapper, which allows to marry UIKit Element with a CCNode. I followed this approach and very quick discovered, that I am working with copy/past for my VO-UI Implementation -> that led to these classes.

How it works:
-------------

* make a CCNode, e.g. a CCLabel
* call the respective method from CCVOHelper, it will return a CCNode with a UIKit element linked to it, so you can access the VO properties
* set the VO properties

And you are good to go.

The example uses the HelloWorldLayer class, all the tying CCNodes with the Helpers to UIKit is in there.  

Additionally you will see:

- CCUIViewWrapper, which is the CCUIViewWrapper-code as found in github
- CCUIViewWrapper+VoiceOver, my category extending CCUIViewWrapper with the possibility to make the UIKit Element make use of an NSNotificationCenter Observer, so I will only be "shown" if VoiceOver is active (this is important for buttons e.g.)
- CCVOHelper, a singelton that sort of wraps arounf CCUIViewWrapper and does stuff like changing the positions from CALayer (Cocos2d Layer grid) to UIKit layer grid

For convenience in testing, I put VoiceOver to the "triple Home Button press". You can decided on your own, if you add the oberserver (NSNotifcationCenter) on object level or if you handle that centrally form the AppDelegate or in multiple places  ...

I mixed both approaches in ECHO, the start screen only has 2 Objects, those are receiving the notification themselves. The menu, incl. CCScrollView and many many CCMenuToggleItems are switched on/off centrally.

One of my biggest problems and probably still a todo is:

 - is the "mother-CCNode" actually on screen? UIKit does *not* care of screen dimensions. So what you do not want to have presentst to  the player, must be set to invisible - otherwise UIAccessibility will read it.

 Outlook:
 --------

 I might be working on this again, since I am guessing that the way I built it is very dirty and might cause memleaks ... So the todo mentioned above and a clear impl. is what I would like to see for myself.

 Take this as a starting point to bring more Acessibility to games! We make them, so we have the chance to add this little piece of extra work for users, that are so good people (at least the ones I am in touch with since ECHO was released are!). Any kind of word or audio driven game can probably be made accessible with a little work.


