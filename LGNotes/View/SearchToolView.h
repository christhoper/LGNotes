//
//  SearchToolView.h
//  NoteDemo
//
//  Created by hend on 2019/3/6.
//  Copyright © 2019 hend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchToolViewConfigure.h"

NS_ASSUME_NONNULL_BEGIN


@protocol SearchToolViewDelegate <NSObject>

- (void)enterSearchEvent;

- (void)filterEvent;

- (void)remarkEvent;


@end

@interface SearchToolView : UIView

@property (nonatomic, weak) id <SearchToolViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                    configure:(SearchToolViewConfigure *)configure;


@end

NS_ASSUME_NONNULL_END
