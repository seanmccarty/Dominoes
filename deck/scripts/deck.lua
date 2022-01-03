function onInit()
    Debug.chat(window.getDatabaseNode());
end

function onDrop(x, y, draginfo)
    return DominoManager.handleAnyDrop(window.getDatabaseNode(), draginfo);
end

function onDragStart(button, x, y, draginfo)
	draginfo.setType("shortcut");
	draginfo.setIcon("button_link");
	local sClass, sRecord = window.link.getValue();
	draginfo.setShortcutData(sClass, sRecord);
	return true;
end