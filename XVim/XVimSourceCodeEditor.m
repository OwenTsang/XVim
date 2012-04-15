//
//  XVimSourceCodeEditor.m
//  XVim
//
//  Created by Tomas Lundell on 31/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XVimSourceCodeEditor.h"
#import "IDESourceCodeEditor.h"
#import "XVimWindow.h"
#import "Hooker.h"
#import "Logger.h"
#import "XVim.h"

@implementation XVimSourceCodeEditor

+ (void) hook
{
    Class delegate = NSClassFromString(@"IDESourceCodeEditor");
	[Hooker hookMethod:@selector(textView:willChangeSelectionFromCharacterRanges:toCharacterRanges:) 
			   ofClass:delegate 
			withMethod:class_getInstanceMethod([self class], @selector(textView:willChangeSelectionFromCharacterRanges:toCharacterRanges:)) 
   keepingOriginalWith:@selector(textView_:willChangeSelectionFromCharacterRanges:toCharacterRanges:)];
    
	[Hooker hookMethod:@selector(initWithNibName:bundle:document:) 
			   ofClass:delegate 
			withMethod:class_getInstanceMethod([self class], @selector(initWithNibName:bundle:document:)) 
   keepingOriginalWith:@selector(initWithNibName_:bundle:document:)];
}

- (NSArray*) textView:(NSTextView *)textView willChangeSelectionFromCharacterRanges:(NSArray *)oldSelectedCharRanges toCharacterRanges:(NSArray *)newSelectedCharRanges
{
    return newSelectedCharRanges;
}

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle document:(NSDocument*)nibDocument{
	IDESourceCodeEditor *editor = (IDESourceCodeEditor*)self;
    [editor initWithNibName_:nibName bundle:nibBundle document:nibDocument];

    [XVim instance].editor = (XVimSourceCodeEditor*)editor;
    return (id)editor;
}

@end