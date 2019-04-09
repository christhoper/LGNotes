//
//  NoteSourceDetailView.h
//  NoteDemo
//
//  Created by hend on 2019/3/29.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SourceDetailViewHidenBlcok)(void);

@interface LGNNoteSourceDetailView : UIView


/**
 类方法

 @return <#return value description#>
 */
+ (LGNNoteSourceDetailView *)showSourceDatailView;

- (void)loadDataWithUrl:(NSString *)url didShowCompletion:(SourceDetailViewHidenBlcok)completion;


@end

NS_ASSUME_NONNULL_END
