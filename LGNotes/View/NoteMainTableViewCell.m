//
//  NoteMainTableViewCell.m
//  NoteDemo
//
//  Created by hend on 2018/10/10.
//  Copyright © 2018年 hend. All rights reserved.
//

#import "NoteMainTableViewCell.h"
#import "Configure.h"

@interface NoteMainTableViewCell ()

@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) UIImageView *subjectBgImageView;
@property (nonatomic, strong) UIImageView *subjectNameImage;
@property (nonatomic, strong) UILabel *editTimeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;

@end

@implementation NoteMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self lg_addSubViews];
    }
    return self;
}


- (void)lg_addSubViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.noteTitleLabel];
    [self.contentView addSubview:self.subjectBgImageView];
    [self.contentView addSubview:self.subjectNameImage];
    [self.contentView addSubview:self.editTimeLabel];
    [self.contentView addSubview:self.sourceLabel];
    
    [self lg_setupSubViewsContraints];
}

- (void)lg_setupSubViewsContraints{
    [self.subjectBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 50));
    }];
    [self.subjectNameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subjectBgImageView).offset(-5);
        make.right.equalTo(self.subjectBgImageView.mas_right).offset(6);
    }];
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subjectBgImageView);
        make.left.equalTo(self.editTimeLabel);
        make.bottom.equalTo(self.sourceLabel.mas_top).offset(-5);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.editTimeLabel.mas_top);
        make.left.equalTo(self.editTimeLabel);
        make.height.mas_equalTo(15);
    }];
    [self.editTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subjectBgImageView).offset(10);
        make.left.equalTo(self.subjectNameImage.mas_right).offset(10);
        make.height.mas_equalTo(18);
    }];
}

- (void)configureCellForDataSource:(NoteModel *)dataSource indexPath:(NSIndexPath *)indexPath{
    NSMutableAttributedString *att = [NoteTools attributedStringByStrings:@[@"来源:",dataSource.ResourceName] colors:@[kLabelColorLightGray,kColorInitWithRGB(0, 153, 255, 1)] fonts:@[@(12),@(12)]];
    self.sourceLabel.attributedText = att;
    self.noteTitleLabel.text = dataSource.NoteTitle;
    self.editTimeLabel.text = [NSString stringWithFormat:@"最近编辑:%@",dataSource.NoteEditTime];
    NSString *subjectName = [NoteTools getSubjectImageNameWithSubjectID:dataSource.SubjectID];
    self.subjectNameImage.image = [NSBundle lg_imagePathName:subjectName];
    NSString *imageName = [NoteTools getSubjectBackgroudImageNameWithSubjectName:dataSource.SubjectName];
    self.subjectBgImageView.image = [NSBundle lg_imagePathName:imageName];
}




#pragma mark - lazy
- (UIImageView *)subjectNameImage{
    if (!_subjectNameImage) {
        _subjectNameImage = [[UIImageView alloc] init];
    }
    return _subjectNameImage;
}


- (UILabel *)editTimeLabel{
    if (!_editTimeLabel) {
        _editTimeLabel = [[UILabel alloc] init];
        _editTimeLabel.text = @"最近编辑:8:30~09:19";
        _editTimeLabel.textColor = [UIColor lightGrayColor];
        _editTimeLabel.font = [UIFont systemFontOfSize:10.f];;
    }
    return _editTimeLabel;
}

- (UIImageView *)subjectBgImageView{
    if (!_subjectBgImageView) {
        _subjectBgImageView = [[UIImageView alloc] init];
        _subjectBgImageView.image = kImage(@"英语");
    }
    return _subjectBgImageView;
}

- (UILabel *)noteTitleLabel{
    if (!_noteTitleLabel) {
        _noteTitleLabel = [[UILabel alloc] init];
        _noteTitleLabel.font = [UIFont systemFontOfSize:15.f];
        _noteTitleLabel.text = @"毛泽东思想，马克思主义，中国特色社会主义核心价值观";
        _noteTitleLabel.numberOfLines = 2;
        _noteTitleLabel.textColor = [UIColor darkGrayColor];
    }
    return _noteTitleLabel;
}

- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
    }
    return _sourceLabel;
}


@end
