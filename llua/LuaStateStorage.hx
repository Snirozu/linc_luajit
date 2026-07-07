package llua;

import llua.State;

// yoo this class was made to prevent lags and leaks
// it is recommended to call LuaStateStorage.clear() right before you close a lua state

private typedef StateStorage = {
	funcs:Array<Dynamic>,
	registryCache:Map<String, Int>,
	callbacks:Map<String, Dynamic>,
}

abstract LuaStateStorage(Array<StateStorage>) {
    public inline function new() {
        this = [];
    }

    function getStateID(l:State):Int {
        Lua.getglobal(l, "___STATE_ID");

        if (Lua.isnil(l, -1) == 1) {
            Lua.pop(l, 1);

            var pickID:Int = 0;
            while (this[pickID] != null) {
                pickID++;
            }

            this[pickID] = {
                funcs: [],
                registryCache: new Map(),
                callbacks: new Map(),
            };

            Lua.pushinteger(l, pickID);
            Lua.pushvalue(l, -1);
            Lua.setglobal(l, "___STATE_ID");
        }

        final id:Int = Lua.tointeger(l, -1);
        Lua.pop(l, 1);
        return id;
    }
    
    @:arrayAccess
    public inline function get(l:State) {
        return this[getStateID(l)];
    }

    public function clear(l:State) {
        this[getStateID(l)] = null;
    }
}