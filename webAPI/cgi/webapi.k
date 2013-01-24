
Import("Does.DCaseCloud");
Import("Type.Json");
Import("Minikonoha.Map");
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
	return true;
}

String run_Create(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "{ \"id\": \"G1\" }", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "{ \"id\": \"G1\" }");
	}
}

/* ----------------------------------------------------------------------- */
/* Insert */

boolean paramCheck_Insert(Json j) {
	return true;
}

String run_Insert(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "{ \"argument_id\": \"0\", \"node_id\": \"11\" }", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "{ \"argument_id\": \"0\", \"node_id\": \"11\" }");
	}
}

/* ----------------------------------------------------------------------- */
/* Update */

boolean paramCheck_Update(Json j) {
	return true;
}

String run_Update(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "\"success\"", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "\"success\"");
	}
}

/* ----------------------------------------------------------------------- */
/* Delete */

boolean paramCheck_Delete(Json j) {
	return true;
}

String run_Delete(Json j) {
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "\"success\"", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "\"success\"");
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
		ret = "{\"HEAD\":\"\",\"root\":{\"description\":\"Basic Syntax\",\"node_id\":\"6\",\"type\":\"Goal\",\"isEvidence\":false},\"argument_id\":\"0\",\"links\":{\"node_id\":\"6\",\"children\":[{\"node_id\":\"7\",\"children\":[]},{\"node_id\":\"8\",\"children\":[{\"node_id\":\"9\",\"children\":[]},{\"node_id\":\"10\",\"children\":[]}]}]},\"branch_id\":\"2\",\"nodes\":[{\"description\":\"Basic Syntax\",\"node_id\":\"6\",\"type\":\"Goal\",\"isEvidence\":false},{\"description\":\"Function Decralation\", \"node_id\":\"9\",\"type\":\"Goal\",\"isEvidence\":false},{\"description\":\"Return Statement\",\"node_id\":\"10\",\"type\":\"Goal\",\"isEvidence\":false},{\"description\":\"Separated by Syntax\", \"node_id\":\"8\",\"type\":\"Strategy\",\"isEvidence\":false},{\"description\":\"Basic Syntax Context\",\"node_id\":\"7\",\"type\":\"Context\",\"isEvidence\":false,\"properties\":{\"OS\":\"Ubuntu 12.04\",\"Architecture\":\"x86_64\",\"C Compiler\":\"GCC 4.6.3\"}}],\"CommitLog\":[]}";
	}
	else {
		//System.p("hello");
		int i = 0;
		while (i < f.getSize()){
			System.p(f[i]);
			if (/Argument/.test(f[i].toString())) {
				//System.p(f[i]);
				ret = "[\"0\"]";
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
	if (j.hasKey("id")) {
		return JsonRPC_formattingWithID("result", "[{ \"argument_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"argument_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }]", j.getInt("id"));
	}
	else {
		return JsonRPC_formatting("result", "[{ \"argument_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"argument_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }]");
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

