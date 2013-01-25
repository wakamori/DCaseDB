
Import("Deos.DCaseCloud");
Import("Type.Json");
Import("MiniKonoha.Map");
Import("Syntax.Null");
Import("Syntax.GlobalVariable");
Import("Syntax.CStyleWhile");
Import("JavaScript.String");
Import("JavaScript.Array");
Import("JavaScript.Regexp");

Load("utils.k");

API repo = new API("dcasedb", "dcasedb");

class WebAPI {

	Map[Func[boolean, Json]] paramCheck;
	Map[Func[String, Json]] run;

	WebAPI() {
		paramCheck = new Map[Func[boolean, Json]];
		run = new Map[Func[String, Json]];
		setCheckParamMethod();
		setRunMethod();
	} 

	void setCheckParamMethod() {
		paramCheck.set("create", paramCheck_Create);
		paramCheck.set("insert", paramCheck_Insert);
		paramCheck.set("update", paramCheck_Update);
		paramCheck.set("delete", paramCheck_Delete);
		paramCheck.set("get", paramCheck_Get);
		paramCheck.set("commit", paramCheck_Commit);
		paramCheck.set("revert", paramCheck_Revert);
		paramCheck.set("diff", paramCheck_Diff);
		paramCheck.set("log", paramCheck_Log);
		paramCheck.set("search", paramCheck_Search);
		paramCheck.set("traverse", paramCheck_Traverse);
	}

	void setRunMethod() {
		run.set("create", run_Create);
		run.set("insert", run_Insert);
		run.set("update", run_Update);
		run.set("delete", run_Delete);
		run.set("get", run_Get);
		run.set("commit", run_Commit);
		run.set("revert", run_Revert);
		run.set("diff", run_Diff);
		run.set("log", run_Log);
		run.set("search", run_Search);
		run.set("traverse", run_Traverse);
	}
}
/* ----------------------------------------------------------------------- */
/* Create */

boolean paramCheck_Create(Json j) {
	boolean ret = true;
	if (!/Context/.test(j.getString("type"))) {
		if (j.hasKey("properties")) {
			ret = false;
		}
	}
	return ret;
}

String run_Create(Json j) {
	// ERROR no argument_id
	DBNode node = global.repo.CreateDBNode(argument_id, j);
	return JsonRPC_fmt(j, "result", "{ \"id\": \"" + node.node_id.toString() + "\"}");
}

/* ----------------------------------------------------------------------- */
/* Insert */

boolean paramCheck_Insert(Json j) {
	return true;
}

String run_Insert(Json j) {
	Json jnode = new Json();
	DBNode node;
	DBNode dist_node;
	int argument_id = j.getString("argument_id").toint();
	if (j.hasKey("new")) {
		jnode = j.get("new");
		node = global.repo.CreateDBNode(argument_id, jnode);
	}
	else {
		int node_id = j.getString("node_id").toint();
		node = global.repo.GetArgument(argument_id).GetDBNode(node_id);
	}

	if (j.hasKey("parent")) {
		Json p = j.get("parent");
		int dist_args_id = p.getString("argument_id").toint();
		int dist_node_id = p.getString("node_id").toint();
		dist_node = global.repo.GetArgument(dist_args_id).GetDBNode(dist_node_id);
		global.repo.InsertLink(argument_id, dist_node, node);
	}
	else if (j.hasKey("child")) {
		Json p = j.get("child");
		int dist_args_id = p.getString("argument_id").toint();
		int dist_node_id = p.getString("node_id").toint();
		dist_node = global.repo.GetArgument(dist_args_id).GetDBNode(dist_node_id);
		global.repo.InsertLink(argument_id, node, dist_node);
	}
	Json ret = new Json();
	ret.setString("argument_id", argument_id.toString());
	ret.setString("node_id", node.node_id.toString());
	return JsonRPC_fmt(j, "result", ret.toString());
}

/* ----------------------------------------------------------------------- */
/* Update */

boolean paramCheck_Update(Json j) {
	return true;
}

String run_Update(Json j) {
	int argument_id = j.getString("argument_id").toint();
	int node_id = j.getString("node_id").toint();
	DBNode node = global.repo.GetArgument(argument_id).GetDBNode(node_id);
	System.p(global.repo.UpdateDBNode(argument_id, node, j));
	return JsonRPC_fmt(j, "result", "\"success\"");
}

/* ----------------------------------------------------------------------- */
/* Delete */

boolean paramCheck_Delete(Json j) {
	return true;
}

String run_Delete(Json j) {
	int argument_id = j.getString("argument_id").toint();
	int node_id = j.getString("node_id").toint();
	//boolean result = repo.DeleteDBNode(argument_id, node_id);
	boolean result = true; // stab
	if (result) {
		return JsonRPC_fmt(j, "result", "\"success\"");
	}
	else {
		return JsonRPC_fmt(j, "error", "{\"code\": -32004, \"Cannot delete node\", \"[webapi:Delete] cannot delete node\"}");
	}
}

/* ----------------------------------------------------------------------- */
/* Get */

boolean paramCheck_Get(Json j) {
	return true;
}

String run_Get(Json j) {
	Json f = j.get("filter");
	String ret;
	if (j.hasKey("argument_id")) {
		ret = global.repo.getArgument(j.getString("argument_id").toint()).toJson().toString();
	}
	else {
		if (f.getSize() == 0) {
			throw_invalidParams(j);
		}
		int i = 0;
		while (i < f.getSize()){
			if (/Argument/.test(f[i].toString())) {
				ret = "[\"0\"]";
				ret = global.repo.GetArgumentIds().toString();
			}
			i = i + 1;
		}
	}
	if (ret == "") {
		ret = "[{ \"argument_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"argument_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }]"
	}
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", ret, j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", ret);
	}
}

/* ----------------------------------------------------------------------- */
/* Commit */

boolean paramCheck_Commit(Json j) {
	return true;
}

String run_Commit(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "\"success\"", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "\"success\"");
	}
}

/* ----------------------------------------------------------------------- */
/* Revert */

boolean paramCheck_Revert(Json j) {
	return true;
}

String run_Revert(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "\"success\"", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "\"success\"");
	}
}

/* ----------------------------------------------------------------------- */
/* Diff */

boolean paramCheck_Diff(Json j) {
	return true;
}

String run_Diff(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "{ \"TODO\": \"nikuuchi\" }", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "{ \"TODO\": \"nikuuchi\" }");
	}
}

/* ----------------------------------------------------------------------- */
/* Log */

boolean paramCheck_Log(Json j) {
	return true;
}

String run_Log(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "[{ \"log\": \"xxxxxx\", \"comment\": \"2nd commit\" },{ \"log\": \"yyyyyy\", \"comment\": \"1st commit\" }]", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "[{ \"log\": \"xxxxxx\", \"comment\": \"2nd commit\" },{ \"log\": \"yyyyyy\", \"comment\": \"1st commit\" }]");
	}
}

/* ----------------------------------------------------------------------- */
/* Search */

boolean paramCheck_Search(Json j) {
	return true;
}

String run_Search(Json j) {
	String keyword = j.getString("keyword");
	Json f = j.get("filter");
	int i = 0;
	Json ret = Json.parse("[]");
	while (i < f.getSize()) {
		ret.add(global.repo.Search(keyword, f[i].toString()));
		i = i + 1;
	}
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", ret.toJson(), j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", ret.toJson());
	}
}

/* ----------------------------------------------------------------------- */
/* Traverse */

boolean paramCheck_Traverse(Json j) {
	return true;
}

String run_Traverse(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "[{ \"argument_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"argument_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }]", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "[{ \"argument_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"argument_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }]");
	}
}

