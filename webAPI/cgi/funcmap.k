
import("Type.Json");
import("Minikonoha.Map");
import("Syntax.Null");
import("Syntax.GlobalVariable");


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
	return "{ \"jsonrpc\": \"2.0\", \"result\": { \"id\": \"G1\" } }";
}

/* ----------------------------------------------------------------------- */
/* Insert */

boolean paramCheck_Insert(Json j) {
	return true;
}

String run_Insert(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": { \"args_id\": \"A1\", \"node_id\": \"S1\" } }";
}

/* ----------------------------------------------------------------------- */
/* Update */

boolean paramCheck_Update(Json j) {
	return true;
}

String run_Update(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": \"success\" }";
}

/* ----------------------------------------------------------------------- */
/* Delete */

boolean paramCheck_Delete(Json j) {
	return true;
}

String run_Delete(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": \"success\" }";
}

/* ----------------------------------------------------------------------- */
/* Get */

boolean paramCheck_Get(Json j) {
	return true;
}

String run_Get(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": [{ \"args_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"args_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }] }";
}

/* ----------------------------------------------------------------------- */
/* Commit */

boolean paramCheck_Commit(Json j) {
	return true;
}

String run_Commit(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": \"success\" }";
}

/* ----------------------------------------------------------------------- */
/* Revert */

boolean paramCheck_Revert(Json j) {
	return true;
}

String run_Revert(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": \"success\" }";
}

/* ----------------------------------------------------------------------- */
/* Diff */

boolean paramCheck_Diff(Json j) {
	return true;
}

String run_Diff(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": { \"TODO\": \"nikuuchi\" } }";
}

/* ----------------------------------------------------------------------- */
/* Log */

boolean paramCheck_Log(Json j) {
	return true;
}

String run_Log(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": [{ \"log\": \"xxxxxx\", \"comment\": \"2nd commit\" },{ \"log\": \"yyyyyy\", \"comment\": \"1st commit\" }] }";
}

/* ----------------------------------------------------------------------- */
/* Search */

boolean paramCheck_Search(Json j) {
	return true;
}

String run_Search(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": [{ \"args_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"args_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }] }";
}

/* ----------------------------------------------------------------------- */
/* Traverse */

boolean paramCheck_Traverse(Json j) {
	return true;
}

String run_Traverse(Json j) {
	return "{ \"jsonrpc\": \"2.0\", \"result\": [{ \"args_id\": \"A1\", \"node_id\": \"G1\", \"type\": \"Goal\", \"description\": \"hello, world\" },{ \"args_id\": \"A1\", \"node_id\": \"C1\", \"type\": \"Context\", \"description\": \"hello, world\", \"properties\": [\"foo\": \"bar\", \"hoge\": \"piyo\"] }] }";
}

