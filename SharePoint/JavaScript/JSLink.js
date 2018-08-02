"use strict";

// メソッドのオーバーライドを行う即時関数
(function () {
	var overrides = {
		'Templates': {
			'Header': 'ヘッダー部HTML',
			'Footer': 'フッター部HTML',
			'Item': function(context) {
				return '<アイテム表示HTML>';
			},
			'Fields': {
				'<フィールド名>': {
					'View': function(context) {
						return '<Viewフィールドテンプレート関数>';
					},
					'DisplayForm': function(context) {
						return '<DispFormフィールドテンプレート関数>';
					},
					'EditForm': function() {
						return '<EditFormフィールドテンプレート関数>';
					},
					'NewForm': function() {
						return '<NewFormフィールドテンプレート関数>';
					}
				}
			}
		}
	};

	// メソッドのオーバーライド
	SPClientTemplates.TemplateManager.RegisterTemplateOverrides(overrides);
})();

// 表示形式を指定する関数
// ※返却値はHTML形式で指定可
function template(context) {
	// フィールド値取得
	var fieldValue = context.CurrentItem["<フィールド名>"];
	return propValue;
}
