//
//  NSString+NotesEmoji.h
//  NoteDemo
//
//  Created by hend on 2019/3/20.
//  Copyright © 2019 hend. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NotesEmoji)

/**
 Calculate the NSRange for every emoji on the string.
 
 @return array with the range for every emoji.
 */
- (NSArray *)emo_emojiRanges;

/**
 Calculate if the string has any emoji.
 
 @return YES if the string has emojis, No otherwise.
 */
- (BOOL)emo_containsEmoji;

/**
 Calculate if the string consists entirely of emoji.
 
 @return YES if the string consists entirely of emoji, No otherwise.
 */
- (BOOL)emo_isPureEmojiString;

/**
 Calculate number of emojis on the string.
 
 @return the total number of emojis.
 */
- (NSInteger)emo_emojiCount;


@end

NS_ASSUME_NONNULL_END
