local coreNode = nil;
function onInit()
    Debug.chat(window.getDatabaseNode());
    buildFromDB();
end

function buildFromDB()
    coreNode = DB.findNode("pf");
    childNodes = DB.getChildren(coreNode);
    Debug.chat(childNodes);
end


function addEntry(bFocus)
    local w = createWindow();
    return w;
end