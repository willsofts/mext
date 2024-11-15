var mouseX = 0;
var mouseY = 0;
//#(10000) programmer code begin;
var grpmenudoc = null;
var menuCounter = 0;
var currentParentNode = null;
var currentNode = null;
var currentMenu = null;
var currentItem = null;
//#(10000) programmer code end;
$(function(){
	$(this).mousedown(function(e) { mouseX = e.pageX; mouseY = e.pageY; });
	try { startApplication("sfte008"); }catch(ex) { }
	initialApplication();
	//#(20000) programmer code begin;
	//#(20000) programmer code end;
});
function initialApplication() {
	//#(30000) programmer code begin;
	//#(30000) programmer code end;
	setupComponents();
	setupAlertComponents();
	//#(40000) programmer code begin;
	//#(40000) programmer code end;
}
function setupComponents() {
	//#(50000) programmer code begin;
	//#(50000) programmer code end;
	$("#explorebutton").click(function(evt) {
		search();  return false;
	});
	$("#savebutton").click(function() {
		disableControls($("#savebutton"));
		save();  return false;
	});
	$("#cancelbutton").click(function() {
		cancel();  return false;
	});
	//#(60000) programmer code begin;
	$("#deletelinker").bind("click",function() { return false; });
	$("input[type=text]",$("#fsentryform")).prop("readonly","true");
	$("#tasklinker").on("click",function() { return newTaskInfo(false); });
	$("#inserttasklinker").on("click",function() { return newTaskInfo(true); });
	$("#itemlinker").on("click",function() { return newItemInfo(); });
	let sourceAry = [];
	for(let p in programs) { 
		sourceAry.push({ label: p+" "+programs[p], value: p, text: programs[p] });
	}
	$("#progid").autocomplete({
		delay: 500, 
		source: sourceAry,
		select : function(event, ui) {
			//console.log(JSON.stringify(ui.item));
			$("#progtitle").val(ui.item.text);
		}
	});
	$("#progiddialog").autocomplete({
		delay: 500, 
		source: sourceAry,
		select : function(event, ui) {
			//console.log(JSON.stringify(ui.item));
			$("#progtitledialog").val(ui.item.text);
		},
		open: function(){
			$(this).autocomplete('widget').css('z-index', 1090);
			return false;
		},	
	});
	$("#progid").autocomplete("widget").addClass("autocomplete-fixed-height");
	$("#progiddialog").autocomplete("widget").addClass("autocomplete-fixed-height");
	//#(60000) programmer code end;
}
function search(aform) {
	//#(70000) programmer code begin;
	let gid = $("#groupname").val();
	//#(70000) programmer code end;
	if(!aform) aform = fssearchform;
	let formdata = serializeDataForm(aform);
	startWaiting();
	jQuery.ajax({
		url: API_URL+"/api/sfte008/retrieve",
		data: formdata.jsondata,
		headers : formdata.headers,
		type: "POST",
		dataType: "json",
		contentType: defaultContentType,
		error : function(transport,status,errorThrown) {
			submitFailure(transport,status,errorThrown);
		},
		success: function(data,status,transport){
			searchComplete(transport,data);
			$("#groupid").val(gid);
			$("#savebutton").attr("disabled",false);
		}
	});	
	//#(80000) programmer code begin;
	//#(80000) programmer code end;
}
function searchComplete(xhr,data) {
	//#(90000) programmer code begin;
	console.log("searchComplete: data",data);
	//#(90000) programmer code end;
	stopWaiting();
	//#(100000) programmer code begin;
	let menu_texts = data?.body?.dataset?.menutext;
	if(!menu_texts || menu_texts.trim().length==0) {
		let text = $("option:selected",$("#groupname")).text();
		menu_texts = "{\"text\":\""+text+"\"}";
	}
	grpmenudoc = JSON.parse(menu_texts);
	currentNode = grpmenudoc;
	currentParentNode = undefined;
	displayMenuTree(currentNode,currentParentNode);
	$("input[type=text]",$("#fsentryform")).removeAttr("readonly");
	//#(100000) programmer code end;
}
function clearingFields() {
	//#(130000) programmer code begin;
	//#(130000) programmer code end;
	fsentryform.reset();
	//#(140000) programmer code begin;
	$("#savebutton").prop("disabled",true);
	$("#updatebutton").prop("disabled",true);
	$(".ctrl-linker").prop("disabled",true);
	$("#deletelinker").unbind("click").bind("click",function() { return false; });
	$("#updatebutton").unbind("click");
	$("#menubarlayer").empty();
	$("input").removeClass("is-invalid");
	$(".alert-input").parent().removeClass("has-error");
	$("input[type=text]",$("#fsentryform")).prop("readonly","true");
	menuCounter = 0;
	currentParentNode = null;
	clearingItems();
	//#(140000) programmer code end;
}
function clearingItems() {
	currentNode = null;
	currentMenu = null;
	for(let p in permits) {
		$("#permitbox"+p).prop("checked",false);
	}
	$("input.permit-checkbox").prop("disabled",true);
	$("input.input-entry").prop("disabled",true).val("");
	$("#progtitle").val("");
}
function cancel() {
	//#(150000) programmer code begin;
	//#(150000) programmer code end;
	confirmCancel(function() {
		clearingFields();
	});
	//#(160000) programmer code begin;
	//#(160000) programmer code end;
}
function validForm() {
	return true;
}
function validSaveForm(callback) {
	//#(170000) programmer code begin;
	//#(170000) programmer code end;
	return validRequiredFields(callback,fs_requiredfields);
	//#(180000) programmer code begin;
	//#(180000) programmer code end;
}
function save(aform) {
	//#(190000) programmer code begin;
	//#(190000) programmer code end;
	if(!aform) aform = fsentryform;
	aform.menutext.value = JSON.stringify(grpmenudoc);
	let childs = grpmenudoc?.items?.length;
	if(!childs || childs<=0) aform.menutext.value = "";
	if(!validForm()) return false;
	validSaveForm(function() {
		//#(195000) programmer code begin;
		//#(195000) programmer code end;
		confirmSave(function() {
			let formdata = serializeDataForm(aform);
			startWaiting();
			jQuery.ajax({
				url: API_URL+"/api/sfte008/update",
				data: formdata.jsondata,
				headers : formdata.headers,
				type: "POST",
				dataType: "html",
				contentType: defaultContentType,
				error : function(transport,status,errorThrown) {
					submitFailure(transport,status,errorThrown);
				},
				success: function(data,status,transport){
					stopWaiting();
					//#(195300) programmer code begin;					
					//#(195300) programmer code end;
					successbox(function() { 
						clearingFields();
					});
					//#(195500) programmer code begin;
					//#(195500) programmer code end;
				}
			});
		});
	});
	return false;
	//#(200000) programmer code begin;
	//#(200000) programmer code end;
}
function submitClear(src,fsParams) {
	//#(310000) programmer code begin;
	//#(310000) programmer code end;
	confirmClear([fsParams[1]],function() {
		clearRecord(fsParams);
	});
	//#(320000) programmer code begin;
	//#(320000) programmer code end;
}
function clearRecord(fsParams) {
	//#(330000) programmer code begin;
	//#(330000) programmer code end;
	let params = {
		ajax: true,
		groupname : fsParams[0]
	};
	let formdata = serializeParameters(params);
	startWaiting();
	jQuery.ajax({
		url: API_URL+"/api/sfte008/clear",
		data: formdata.jsondata,
		headers: formdata.headers,
		type: "POST",
		dataType: "html",
		contentType: defaultContentType,
		error : function(transport,status,errorThrown) {
			submitFailure(transport,status,errorThrown);
		},
		success: function(data,status,transport){
			stopWaiting();
			//#(333000) programmer code begin;
			//#(333000) programmer code end;
			successbox(function() { 
				clearingFields();
			});
			//#(335000) programmer code begin;
			//#(335000) programmer code end;
		}
	});
	//#(340000) programmer code begin;
	//#(340000) programmer code end;
}
//#(390000) programmer code begin;
var fs_requiredfields = {
};
function selectLinker($a) {
	try{
		$("a",$("#menubarlayer")).removeClass("selected-linker");
		$a.addClass("selected-linker");
	}catch(ex) { }
}
function displayMenuTree(curnode,parentnode) {
	clearingFields();
	let $menu = $("<ul id=\"menuitemlist\" class=\"nav sidebar-nav\" role=\"menu\"></ul>");
	updateItemToMenu(curnode,parentnode,$menu);
	$("#menubarlayer").empty().append($menu);
}
function updateItemToMenu(curnode,parentnode,menu) {
	let isz = curnode?.items ? curnode.items.length : 0;
	let $li = $("<li></li>");
	let txt = curnode.text;
	if(!txt) txt = "";
	let $ul = $("<ul></ul>");
	$ul.attr("id","#submenu_"+menuCounter);
	$ul.addClass("panel-collapse");
	$ul.attr("role","menu");
	$ul.attr("counter",menuCounter);	
	if(isz==0) { 
		let itemname = curnode.itemname;
		if(!itemname) itemname = "";
		let $a = $("<a></a>");
		$a.attr("href","javascript:void(0);");
		$a.addClass("fa fa-desktop");
		let $span = $("<span></span>");
		$span.html(" "+txt);
		let rootTag = parentnode;
		if(!rootTag || $.trim(itemname)=="") {
			$li.addClass("dropdown");
			$a.attr("href","javascript:void(0);");
			$a.attr("counter",menuCounter);
			$a.removeClass("fa fa-desktop").addClass("fa fa-tasks dropdown-toggle fa-folder-link");
			let $aul = $("<ul></ul>");
			$aul.attr("id","#submenu_"+menuCounter);
			$aul.addClass("panel-collapse");
			$aul.attr("role","menu");
			$aul.attr("counter",menuCounter);
			$a.append($span);
			$li.append($a);
			$li.append($aul);
			menu.append($li);
			$a.click(function()  {
				currentParentNode = parentnode;
				currentNode = curnode;
				currentMenu = $aul;
				currentItem = $li;
				bindingTask(curnode,parentnode,$span,$aul,$a);
			});
		} else {
			$a.append($span);
			$li.append($a);
			menu.append($li);
			$a.click(function()  {
				currentParentNode = parentnode;
				currentNode = curnode;
				currentMenu = menu;
				currentItem = $li;
				bindingItem(curnode,parentnode,$span,menu,$a);
			});
		}
	} else {
		$li.addClass("dropdown");
		let $a = $("<a></a>");
		$a.attr("href","javascript:void(0);");
		$a.attr("counter",menuCounter);
		$a.addClass("fa fa-tasks");
		let $span = $("<span></span>");
		$span.html(" "+txt);
		$a.append($span);
		$li.append($a);
		$li.append($ul);
		menu.append($li);
		$a.click(function() { 
			currentParentNode = parentnode;
			currentNode = curnode;
			currentMenu = $ul;
			currentItem = $li;
			bindingTask(curnode,parentnode,$span,$ul,$a);
		});
	}
	let childs = curnode.items;
	if(childs && childs.length>0) {
		childs.forEach(function(element) {
			if(element) {
				menuCounter++;
				updateItemToMenu(element,curnode,$ul);
			}
		});
	}
}
function bindingTask(curnode,parentnode,$span,menu,linker) {
	//console.log("bindingTask: curnode",curnode,"parentnode",parentnode);
	selectLinker(linker);
	$("input").removeClass("is-invalid");
	$(".alert-input").parent().removeClass("has-error");
	$(".ctrl-linker").prop("disabled",false);
	$("#updatebutton").prop("disabled",false);
	let txt = curnode.text;
	if(!txt) txt = "";
	$("#progid").val("");
	$("#progtitle").val(txt);
	$("input.permit-checkbox").prop("checked",false);
	$("input.permit-checkbox").prop("disabled",true);
	$("#parameters").val("");
	$("input.input-entry").prop("disabled",true);
	let rootTag = parentnode;
	$("#deletelinker").unbind("click").bind("click",function() { 
		if(!rootTag) { alertmsg("QS0124","Can not remove root node"); } else {
			confirmRemoveNode([txt],function() {
				let items = parentnode.items.filter((element) => element != curnode);
				parentnode.items = items;
				menu.remove();
				linker.parent().remove();
				clearingItems();
				//console.log("Task-Remove: grpmenudoc",grpmenudoc);
			});
		}
		return false;
	});
	$("#updatebutton").unbind("click").bind("click",function() { 
		let validator = null;
		if($.trim($("#progtitle").val())=="") {
			$("#progtitle").addClass("is-invalid");
			$("#progtitle").parent().addClass("has-error");
			if(!validator) validator = "progtitle";
		}
		if(validator) {
			$("#"+validator).focus();
			setTimeout(function() { 
				$("#"+validator).addClass("is-invalid");
				$("#"+validator).parent().addClass("has-error");
			},100);
			return false;
		}
		txt = $("#progtitle").val();
		$span.html(" "+txt);
		curnode.text = txt;
		//console.log("Task-Update: grpmenudoc",grpmenudoc);
		updateSuccess();
	});			
}
function bindingItem(curnode,parentnode,$span,menu,linker) {
	//console.log("bindingItem: curnode",curnode,"parentnode",parentnode);
	selectLinker(linker);
	$("input").removeClass("is-invalid");
	$(".alert-input").parent().removeClass("has-error");
	$(".ctrl-linker").prop("disabled",false);
	$("#itemlinker").prop("disabled",false); 
	$("#updatebutton").prop("disabled",false);
	let pid = curnode.itemname;
	let para = curnode.parameters;
	let txt = curnode.text;
	let curpermits = curnode.permits;
	if(!pid) pid = "";
	if(!para) para = "";
	if(!txt) txt = "";
	if(!curpermits) curpermits = {};
	$("#progid").val(pid);
	$("#progtitle").val(txt);
	$("input.input-entry").prop("disabled",false);
	$("input.permit-checkbox").prop("disabled",false);
	for(let p in permits) {
		let pstr = String(curpermits[p]);
		$("#permitbox"+p).prop("checked","true"==pstr);
	}
	$("#parameters").val(para);
	let rootTag = parentnode;
	$("#deletelinker").unbind("click").bind("click",function() { 
		if(!rootTag) { alertmsg("QS0124","Can not remove root node"); } else {
			confirmRemoveNode([txt],function() {
				let items = parentnode.items.filter((element) => element != curnode);
				parentnode.items = items;
				linker.parent().remove();
				clearingItems();
				//console.log("Item-Remove: grpmenudoc",grpmenudoc);
			});	
		}
		return false;
	});
	$("#updatebutton").unbind("click").bind("click",function() { 
		let validator = null;
		if($.trim($("#progid").val())=="") {
			$("#progid").addClass("is-invalid");
			$("#progid").parent().addClass("has-error");
			if(!validator) validator = "progid";
		}
		if($.trim($("#progtitle").val())=="") {
			$("#progtitle").addClass("is-invalid");
			$("#progtitle").parent().addClass("has-error");
			if(!validator) validator = "progtitle";
		}
		if(validator) {
			$("#"+validator).focus();
			setTimeout(function() { 
				$("#"+validator).addClass("is-invalid");
				$("#"+validator).parent().addClass("has-error");
			},100);
			return false;
		}
		txt = $("#progtitle").val();
		$span.html(" "+txt);
		curnode.text = txt;
		curnode.itemname = $("#progid").val();
		let curperm = {};
		for(let p in permits) {
			curperm[p] = $("#permitbox"+p).is(":checked");
		}
		curnode.permits = curperm;
		curnode.parameters = $("#parameters").val();
		//console.log("Item-Update: grpmenudoc",grpmenudoc);
		updateSuccess();
	});
}
function newTaskInfo(inserted) {
	if(!currentNode || !currentMenu) return false;	
	$("#progtitletask").val("");
	$("#progtitletask").removeClass("is-invalid").blur(function() { $("#progtitletask").removeClass("is-invalid"); });
	$("#okbuttondialogtask").unbind("click").bind("click",function() { 
		let txt = $("#progtitletask").val();
		if($.trim(txt)=="") {
			$("#progtitletask").addClass("is-invalid");
			$("#progtitletask").focus();
			return;
		}
		let curnode = {};
		let parentnode = currentParentNode;
		let rootTag = currentParentNode;
		if(inserted) {
			if(!rootTag) {
				let curitems = currentNode?.items;
				if(!curitems) {
					curitems = [];
					currentNode.items = curitems;
				}
				curitems.push(curnode);	
				parentnode = currentNode;
				//console.log("Task-1: cur items",curitems);
			} else {
				let parentitems = parentnode?.items;
				if(!parentitems) {
					parentitems = [];
					parentnode.items = parentitems;
				}
				if(parentitems.length==0) {
					parentitems.push(curnode);
				} else {
					let index = parentitems.findIndex(element => element == currentNode);
					if(index !== -1) {
						parentitems.splice(index+1,0,curnode);
					}
				}
				//console.log("Task-2: parent items",parentitems);
			}
		} else {
			let curitems = currentNode?.items;
			if(!curitems) {
				curitems = [];
				currentNode.items = curitems;
			}
			curitems.push(curnode);
			parentnode = currentNode;
			//console.log("Task-3: cur items",curitems);
		}		
		menuCounter++;
		curnode.text = txt;
		let $li = $("<li></li>");
		$li.addClass("dropdown");
		let $a = $("<a></a>");
		$a.attr("href","javascript:void(0);");
		$a.addClass("fa fa-tasks");
		let $span = $("<span></span>");
		$span.html(" "+txt);
		$a.append($span);
		$li.append($a);
		let $ul = $("<ul></ul>");
		$ul.attr("id","#submenu_"+menuCounter);
		$ul.addClass("panel-collapse");
		$ul.attr("role","menu");
		$ul.attr("counter",menuCounter);
		$li.append($ul);
		if(inserted) {
			if(!rootTag) {
				currentMenu.append($li);
			} else {
				currentItem.after($li);
			}
		} else {
			currentMenu.append($li);
		}
		$a.click(function() {
			currentParentNode = parentnode; 
			currentNode = curnode;
			currentMenu = $ul;
			currentItem = $li;
			bindingTask(curnode,parentnode,$span,$ul,$a);
		});
		$("#task_dialog_layer").modal("hide");
		//console.log("Task-New: grpmenudoc",grpmenudoc);
	});	
	$("#task_dialog_layer").modal("show");
	$("#task_dialog_layer").find(".modal-dialog").draggable();
	$("#task_dialog_layer").on("shown.bs.modal",function() { $("#progtitletask").focus(); });
	return false;
}
function newItemInfo() {
	if(!currentNode || !currentMenu) return false;
	$("#progiddialog").removeClass("is-invalid").blur(function() { $("#progiddialog").removeClass("is-invalid"); });
	$("#progtitledialog").removeClass("is-invalid").blur(function() { $("#progtitledialog").removeClass("is-invalid"); });
	$("#groupnamedialog").val($("#groupid").val());
	$("input.input-item").val("");
	$("input.permitdialog-checkbox").attr("checked",false);
	$("input.permit-input").val("false");
	$("#okbuttondialogitem").unbind("click").bind("click",function() { 
		let validator = null;
		let pid = $("#progiddialog").val();
		if($.trim(pid)=="") {
			$("#progiddialog").addClass("is-invalid");
			validator = "progiddialog";
		}
		let txt = $("#progtitledialog").val();
		if($.trim(txt)=="") {
			$("#progtitledialog").addClass("is-invalid");
			if(!validator) validator = "progtitledialog";
		}
		if(validator) {
			$("#"+validator).focus();
			return false;
		}
		insertProgItem(function() {
			let curnode = {};
			let parentnode = currentParentNode;
			let itemname = currentNode.itemname;
			if(itemname && itemname!="") {
				let parentitems = parentnode?.items;
				if(!parentitems) {
					parentitems = [];
					parentnode.items = parentitems;
				}
				if(parentitems.length==0) {
					parentitems.push(curnode);
				} else {
					let index = parentitems.findIndex(element => element == currentNode);
					if(index !== -1) {
						parentitems.splice(index+1,0,curnode);
					}
				}
				//console.log("Item-1: parent items",parentitems);
			} else {
				let curitems = currentNode?.items;
				if(!curitems) {
					curitems = [];
					currentNode.items = curitems;
				}
				curitems.push(curnode);
				parentnode = currentNode;
				//console.log("Item-2: parent items",curitems);
			}
			curnode.itemname = pid;
			curnode.text = txt;
			let curperm = {};
			for(let p in permits) {
				curperm[p] = $("#permitdialog"+p).is(":checked");
			}
			curnode.permits = curperm;
			curnode.parameters = $("#parametersdialog").val();
			let $li = $("<li></li>");
			let $a = $("<a></a>");
			$a.attr("href","javascript:void(0);");
			$a.addClass("fa fa-desktop");
			let $span = $("<span></span>");
			$span.html(" "+txt);
			$a.append($span);
			$li.append($a);
			if(itemname && itemname!="") {
				currentItem.after($li);
			} else {
				currentMenu.append($li);
			}
			let acurrentMenu = currentMenu;
			$a.click(function() {
				currentParentNode = parentnode;  
				currentNode = curnode;
				currentMenu = acurrentMenu;
				currentItem = $li;
				bindingItem(curnode,parentnode,$span,acurrentMenu,$a);
			});
			$("#item_dialog_layer").modal("hide");
			//console.log("Item-New: grpmenudoc",grpmenudoc);
		});
	});
	$("#item_dialog_layer").modal("show");
	$("#item_dialog_layer").find(".modal-dialog").draggable();
	$("#item_dialog_layer").on("shown.bs.modal",function() { $("#progiddialog").focus(); });
	return false;
}
function confirmRemoveNode(params, okFn, cancelFn,  width, height) {
	if(!confirmDialogBox("QS0034",params,"Do you want to remove this node?",okFn,cancelFn,width,height)) return false;
	return true;
}
function toggleValueClick(src,ctrl) {
	$("#"+ctrl).val($(src).is(":checked"));
}
function insertProgItem(callback) {
	if(callback) callback();
}
function updateSuccess(callback,params) {
	alertbox("QS0104",callback,null,params);
}
//#(390000) programmer code end;
