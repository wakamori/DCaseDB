import("konoha.ns");
import("konoha.json");
import("openssl");
import("cstyle");
import("java2.class");
import("konoha.map");
import("konoha.sql");
import("konoha.object");
import("js4.array");
import("js4.date");
//Import("MiniKonoha.NameSpace");
//Import("Type.Json");
//Import("Lib.Openssl");
//Import("Syntax.CStyleFor");
//Import("Java.Class");
//Import("MiniKonoha.Map");
//Import("MiniKonoha.Sql");
//Import("JavaStyle.Object");
//Import("JavaScript.Array");
//Import("JavaScript.Date");

class DBNode {
	String nodeId;
	String description;
	boolean isEvidence;

	String parentId;
	String[] childIds;

	DBNode(String nodeId, String description, boolean isEvidence,String parentId) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = isEvidence;
		this.parentId    = parentId;
		this.childIds    = [];
	}

	DBNode(String nodeId, String description, boolean isEvidence) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = isEvidence;
		this.parentId    = "";
		this.childIds    = [];
	}

	DBNode(String nodeId, String description) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = false;
		this.parentId    = "";
		this.childIds    = [];
	}

	DBNode(String nodeId) {
		this.nodeId      = nodeId;
		this.description = "";
		this.isEvidence  = false;
		this.parentId    = "";
		this.childIds    = [];
	}

	DBNode(Json content) {
		this.nodeId      = "";
		this.description = "";
		this.isEvidence  = "";
		this.parentId    = "";
		this.childIds    = [];
		this._Update(content);
	}

	void AddChild(DBNode childNode) {
		this.childIds.add(childNode.nodeId);
		childNode.parentId = this.nodeId;
	}

	//Private
	void _Update(Json content) {
		if(content.hasKey("nodeId")) {
			this.name = content.getString("nodeId");
		}
		if(content.hasKey("description")) {
			this.description = content.getString("description");
		}
		if(content.hasKey("isEvidence")) {
			this.isEvidence = content.getBoolean("isEvidence");
		}
		if(content.hasKey("parentId")) {
			this.parentId = content.getString("parentId");
		}
	}

	Json Update(Json content) {
		Json json = new Json();
		json.set("before",this.toJson());
		this._Update(content);
		json.set("after", this.toJson());
		return json;
	}

	Json _toJson() {
		Json json = new Json();
		json.setString("nodeId",this.name);
		json.setString("description",this.description);
		json.setBoolean("isEvidence",this.isEvidence);
		return json;
	}

	Json toJson() {
		return this._toJson();
	}
}

class Context extends DBNode {
	Json context; //FIXME

	Context(Json content) {
		//TODO Create Argument
		this.context = new Json();
		this._Update(content);
		if(content.hasKey("context")) {
			Json array = content.get("context");
			String[] keys = array.keys();
			for(int i = 0; i < keys.getSize(); i++) {
				this.context.setString(keys[i],array.getString(keys[i]));//TODO validation
			}
		}
	}

	String searchValue(String key) {
		if(this.context.hasKey(key)) {
			return this.context.getString(key);
		}
		return NULL;
	}

	void addKeyValues(Json json) {
		String[] keys = json.keys();
		for(int i = 0; i < keys.getSize(); i++) {
			this.context.setString(keys[i],json.getString(keys[i])); //TODO Need validation
		}
	}

	void addKeyValue(String key, String value) {
		this.context.setString(key,value);
	}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Context");
		json.set("context",this.context);
		return json;
	}
}

//FIXME Need ContextNode information?
class Goal extends DBNode {
	Goal(){}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Goal");
		return json;
	}

	//TODO
	Json GetContext() {
	}
}

class Strategy extends DBNode {
	Strategy(){}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Strategy");
		return json;
	}

	//TODO
	Json GetContext() {
	}
}

class Evidence extends DBNode {
	Evidence() {}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Evidence");
		return json;
	}
}

//TODO
class Justification extends DBNode {
	Justification(){}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Justification");
		return json;
	}
}

//TODO
class Rebuttal extends DBNode {
	Rebuttal(){}

	Json toJson() {
		Json json = this._toJson();
		json.setString("DBNodeType","Rebuttal");
		return json;
	}
}

/*
class Link {
	String parentID;
	String childID;
	Link(String parent, String child) {
		this.parentID = parent;
		this.childID = child;
	}

	Link(Json content) {
		if(content.hasKey("parentID")) {
			this.parentID = content.getString("parentID");
		}
		if(content.hasKey("childID")) {
			this.childID  = content.getString("childID");
		}
	}

	Json toJson() {
		Json json = new Json();
		json.setString("parentID",this.parent);
		json.setString("childID",this.child);
		return json;
	}
}
*/

class Commit {
	String method;
	Json   args;
	String revision;
	int time;

	Commit() {
	}

	Commit(String method, Json args, String revision) {
		this.method   = method;
		this.args     = args;
		this.revision = revision;
		this.time     = new Date().getTime();
	}

	Json toJson() {
		Json json = new Json();
		json.setString("method",this.method);
		json.set("args",this.args);
		json.setString("revision",this.revision);
		json.setInt("time",this.time);
		return json;
	}
}

class CommitLog {
	Commit[] commits;
	String head;
	SHA1 sha1;

	CommitLog() {
		this.commits = [];
		this.sha1 = new SHA1();
		this.sha1.update(new Date().toString());
	}

	Commit addCommit(String method, Json argument) {
		Commit commit = new Commit(method, argument, this.sha1.final());
		this.commits.add(commit);
		this.head = commit.revision;
		return commit;
	}

	Json toJson() {
		Json json = Json.parse("[]");
		for(int i = 0;i < this.commits.getSize(); i++) {
			json.add(this.commits[i].toJson());
		}
		return json;
	}

}

class Argument {
	String argumentId;
	Map[Branch] branches; //FIXME Map

	Argument() {
		this.branches.set("master", new Branch());
	}

	@Public Branch GetBranch(String BranchId) {
		return this.branches.get(BranchId);
	}

	@Public Branch Fork(String originId, String newId, Contex ctx) {
		this.Fork(originId, newId, ctx, this.GetBranch(originId).commitLog.head);
	}

	@Public Argument Fork(String originalId, String newId, Context ctx, String revision) {
	}
}

class Branch {
	String branchId;
	CommitLog commitLog;
	DBNode root;
	DBNode[] nodes;

	Branch() {
		this.root = NULL;
		this.commit_log = new CommitLog();
		this.nodes = [];
	}

	Branch(DBNode[] nodes, CommitLog cl,DBNode root) {
		this.commit_log = cl;
		this.nodes = nodes;
		this.root = root;
	}

	Commit Commit(String method, Json argument) {
		return this.commit_log.addCommit(method,argument);
	}

	//TODO
	@Public Json toJson() {
		Json json = new Json();
		return json;
	}
}

class DBDriver {

}

class DriverMySQL extends DBDriver {
	DriverMySQL(String userName, String password) {
	}
}

class API {
	Map[Argument] arguments;
	DBDriver db;

	API() {
	}

	API(String userName, String password) {
		this.Connect(userName, password);
	}

	@Public void Connect(String userName, String password) {
		this.db = new DriverMySQL(userName, password);
	}

	@Public Argument CreateArgument(String argumentId, String description) {
	}

	@Public Argument GetArgument(String argumentId) {
		return this.arguments.get(argumentId);
	}

	@Public String[] GetArgumentIds() {
		return []; //FIXME
	}

	@Public DBNode[] SearchDBNode(String searchText) {
		return []; //FIXME
	}

	@Public DBNode CreateDBNode(String name, Json content) {
	}
}
