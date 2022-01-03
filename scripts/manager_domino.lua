function onInit()
    Debug.chat("starting");
    DB.createNode(deckNode);
	DB.createNode("pf");
	DB.setPublic("pf", true);
    --if DB.getChildCount(deckNode)==0 then buildDeck(6); end
	resetDeck();
end

deckNode = "deck.handlist"


function buildDeck(size)
    if size==0 or size>25 then Debug.chat("Decks must have a max number between 0 and 25, exclusive") return; end
    for side1 = 0, size do
        for side2 = 0, side1 do
            tempNode = DB.createChild(deckNode)
            DB.setValue(tempNode,"name","string",tostring(side1) .. "_" .. tostring(side2));
            DB.setValue(tempNode,"side1","number",side1);
            DB.setValue(tempNode,"side2","number",side2);
        end
    end
end

function resetDeck()
	DB.deleteChildren(deckNode);
	buildDeck(6);
end

function moveDomino(sourceNode, destNode)
    Debug.chat(sourceNode, destNode);
    destNode = DB.createChild(destNode);
    DB.copyNode(sourceNode, destNode);
    DB.deleteNode(sourceNode);
end

function handleAnyDrop(vTarget, draginfo)
	local sDragType = draginfo.getType();
    Debug.chat(vTarget, draginfo);
	
	if not Session.IsHost then
		local sTargetType = ItemManager.getItemSourceType(vTarget);
		if sTargetType == "item" then
			return false;
		elseif sTargetType == "treasureparcel" then
			return false;
		elseif sTargetType == "partysheet" then
			if sDragType ~= "shortcut" then
				return false;
			end
			local sClass, sRecord = draginfo.getShortcutData();
			if not LibraryData.isRecordDisplayClass("item", sClass) then
				return false;
			end
			local sSourceType = ItemManager.getItemSourceType(sRecord);
			if sSourceType ~= "charsheet" then
				return false;
			end
		elseif sTargetType == "charsheet" then
			if not DB.isOwner(vTarget) then
				return false;
			end
		end
	end
	
	if sDragType == "number" then
		ItemManager.handleString(vTarget, draginfo.getDescription(), draginfo.getNumberData());
		return true;

	elseif sDragType == "string" then
		ItemManager.handleString(vTarget, draginfo.getStringData());
		return true;

	elseif sDragType == "shortcut" then
		local sClass,sRecord = draginfo.getShortcutData();
		moveDomino(sRecord,DB.getPath(vTarget,"handlist"));
	end
	
	return false;
end