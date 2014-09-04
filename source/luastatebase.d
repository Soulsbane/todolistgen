module luastatebase;

import luad.all;

class LuaStateBase
{
	static this()
	{
		this.lua_ = new LuaState;
		this.lua_.openLibs();
	}

	@property LuaState lua()
	{
		return this.lua_;
	}
private:
	static LuaState lua_;
}
