# Template Label File

### JSON Label File
This is example of json label file layout template for import

```javascript
[
	{
		"language": "TH",
		"label": [
			{"name": "caption", "value": "การตรวจสอบ"},
			{"name": "submitbutton", "value": "ยอมรับ"},
			{"name": "factorcode_label", "value": "รหัสตรวจสอบ"},
			{"name": "factorcode_alert", "value": "กรุณากรอกข้อมูล"}		
        ]
	},
	{
		"language": "EN",
		"label": [
			{"name": "caption", "value": "Verification"},
			{"name": "submitbutton", "value": "Submit"},
			{"name": "factorcode_label", "value": "Verify Code"},
			{"name": "factorcode_alert", "value": "You can not leave this empty"}		
        ]
	}
]
```

### Excel Label File
This is example of excel label file layout template for import

| Program | Language | Label Name | Value |
| -------- | ---- | ------- | ----------- |
| index.xml | EN | caption | Verification |
| index.xml | EN | submitbutton | Submit |
| index.xml | EN | factorcode_label | Verify Code |
| index.xml | EN | factorcode_alert | You can not leave this empty |
| index.xml | TH | caption | การตรวจสอบ |
| index.xml | TH | submitbutton | ยอมรับ |
| index.xml | TH | factorcode_label | รหัสตรวจสอบ |
| index.xml | TH | factorcode_alert | กรุณากรอกข้อมูล |
