module luastatebase;

import luad.all;
import luad.error;

static void panic(LuaState lua, in char[] error)
{
	import std.stdio;
	writeln("Lua parsing error!\n", error, "\n");
}

class LuaStateBase
{
	static this()
	{
		this.lua_ = new LuaState;
		this.lua_.openLibs();
		this.lua_.setPanicHandler(&panic);
	}

	@property LuaState lua()
	{
		return this.lua_;
	}
private:
	static LuaState lua_;
}
