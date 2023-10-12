/* Thai initialisation for the jQuery UI date picker plugin. */
/* Written by pipo (pipo@sixhead.com). */
jQuery(function($){
	$.datepicker.regional['th'] = {
		yearOffSet: 543,
		closeText: '�Դ',
		prevText: '&#xAB;&#xA0;��͹',
		nextText: '�Ѵ�&#xA0;&#xBB;',
		currentText: '�ѹ���',
		monthNames: ['���Ҥ�','����Ҿѹ��','�չҤ�','����¹','����Ҥ�','�Զع�¹','�á�Ҥ�','�ԧ�Ҥ�','�ѹ��¹','���Ҥ�','��Ȩԡ�¹','�ѹ�Ҥ�'],
		monthNamesShort: ['�.�.','�.�.','��.�.','��.�.','�.�.','��.�.','�.�.','�.�.','�.�.','�.�.','�.�.','�.�.'],
		dayNames: ['�ҷԵ��','�ѹ���','�ѧ���','�ظ','����ʺ��','�ء��','�����'],
		dayNamesShort: ['��.','�.','�.','�.','��.','�.','�.'],
		dayNamesMin: ['��.','�.','�.','�.','��.','�.','�.'],
		weekHeader: 'Wk',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['th']);
});
