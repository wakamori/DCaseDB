//import("konoha.ns");
//import("konoha.json");
//import("openssl");
//import("cstyle");
//import("java2.class");
//import("konoha.map");
//import("konoha.sql");
//import("konoha.object");
//import("js4.array");
//import("js4.date");

Import("Type.Json");
Import("Lib.Openssl");
Import("Syntax.CStyleFor");
Import("Syntax.CStyleWhile");
Import("Syntax.Null");
Import("Java.Class");
Import("MiniKonoha.NameSpace");
Import("MiniKonoha.Map");
Import("MiniKonoha.Sql");
Import("JavaStyle.Object");
Import("JavaScript.Array");
Import("JavaScript.Date");

class DBNode {
	int nodeId;
	String description;
	int argumentId;
	int branchId;
	boolean isEvidence;

	DBNode parent;
	DBNode[] children;

	DBNode(int nodeId, String description, boolean isEvidence) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = isEvidence;
		this.children    = [];
	}

	DBNode(int nodeId, String description) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = false;
		this.children    = [];
	}

	DBNode(int nodeId) {
		this.nodeId      = nodeId;
		this.description = "";
		this.isEvidence  = false;
		this.children    = [];
	}

	DBNode(Json content) {
		this.description = "";
		this.isEvidence  = false;
		this.children    = [];
		this.PrivateUpdate(content);
	}

	void AddChild(DBNode child) {
		this.children.add(child);
		child.parent = this;
	}

	void RemoveChild(DBNode child) {
		for(int i = 0; i < this.children.getSize(); i = i + 1) {
			if(this.children[i].nodeId == child.nodeId){
				children.removeAt(i);
				break;
			}
		}
		child.parent = NULL;
	}

	void AddParent(DBNode parent) {
		this.parent = parent;
		parent.children.add(this);
	}

	//Private
	void PrivateUpdate(Json content) {
		if(content.hasKey("description")) {
			this.description = content.getString("description");
		}
		if(content.hasKey("isEvidence")) {
			this.isEvidence = content.getBoolean("isEvidence");
		}
	}

	Json Update(Json content) {
		Json json = new Json();
		json.set("before",this.toJson());
		this.PrivateUpdate(content);
		json.set("after", this.toJson());
		return json;
	}

	Json PrivateToJson() {
		Json json = new Json();
		json.setInt("nodeId",this.nodeId);
		json.setString("description",this.description);
		json.setBoolean("isEvidence",this.isEvidence);
		return json;
	}

	Json toJson() {
		Json json = this.PrivateToJson();
		return json;
	}

	Json GetContext() {
		//Abstract
		return NULL;
	}

	void AddContext(Json context) {
		//Abstract
	}
}

class Context extends DBNode {
	Json context; //FIXME

	Context(Json content) {
		//TODO Create Argument
		this.context = new Json();

		this.PrivateUpdate(content);
		if(content.hasKey("context")) {
			Json array = content.get("context");
			String[] keys = array.keys();
			for(int i = 0; i < keys.getSize(); i = i + 1) {
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

	void addKeyValue(String key, String value) {
		this.context.setString(key,value);
	}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Context");
		json.set("context",this.context);
		return json;
	}

	Json GetContext() {
		return this.context;
	}

	void AddContext(Json context) {
		String[] keys = context.keys();
		for(int i = 0; i < keys.getSize(); i = i + 1) {
			this.context.setString(keys[i],context.getString(keys[i])); //TODO Need validation
		}
	}
}

class Goal extends DBNode {
	Goal(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Goal");
		return json;
	}

	//FIXME validation
	Json GetContext() {
		Json json = this.parent.GetContext();
		Json context_array = Json.parse("[]");
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				context_array.add(c.GetContext());
			}
		}
		for(int i = 0; i < context_array.getSize();i = i + 1) {
			Json context = context_array.get(i);
			String[] keys = context.keys();
			for(int j = 0; j < keys.getSize(); j = j + 1) {
				json.setString(keys[i],context.getString(keys[i]));
			}
		}
		return json;
	}

	void AddContext(Json context) {
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				c.AddContext(context);
				return;
			}
		}
		//FIXME if there is no Context, add new Context(not here?)
	}
}

class Strategy extends DBNode {
	Strategy(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Strategy");
		return json;
	}

	//FIXME validation
	Json GetContext() {
		Json json = this.parent.GetContext();
		Json context_array = Json.parse("[]");
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				context_array.add(c.GetContext());
			}
		}
		for(int i = 0; i < context_array.getSize();i = i + 1) {
			Json context = context_array.get(i);
			String[] keys = context.keys();
			for(int j = 0; j < keys.getSize(); j++) {
				json.setString(keys[i],context.getString(keys[i]));
			}
		}
		return json;
	}

	void AddContext(Json context) {
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				c.AddContext(context);
				break;
			}
		}
	}
}

class Evidence extends DBNode {
	Evidence() {}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Evidence");
		return json;
	}

	Json GetContext(){
		return this.parent.GetContext();
	}
}

//TODO
class Justification extends DBNode {
	Justification(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Justification");
		return json;
	}
}

//TODO
class Rebuttal extends DBNode {
	Rebuttal(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Rebuttal");
		return json;
	}
}

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
		for(int i = 0;i < this.commits.getSize(); i = i + 1) {
			json.add(this.commits[i].toJson());
		}
		return json;
	}

}

class Branch {
	int branchId;
	int argumentId;
	DBNode root;
	DBNode[] nodes;

	Branch() {
		this.root = NULL;
		this.nodes = [];
	}

	Branch(DBNode[] nodes, DBNode root) {
		this.nodes = nodes;
		this.root = root;
	}

	DBNode GetDBNode(int nodeId) {
		if(this.root.nodeId == nodeId) {
			return this.root;
		}
		int i = 0;
		//for(int i = 0; i < this.nodes.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.nodes.getSize()) {
			System.p(nodeId == this.nodes[i].nodeId);
			if(this.nodes[i].nodeId == nodeId) {
				return this.nodes[i];
			}
			i = i + 1;
		}
		return NULL;
	}

	Json DBNodeListToJson() {
		Json json = Json.parse("[]");
		int max = this.nodes.getSize();
		//for(int i = 0; i < max; i = i + 1) {
		int i = 0;
		while(i < max) {
			json.add(this.nodes[i].toJson());
			i = i + 1;
		}
		return json;
	}

	Json PrivateArgumentTreeToJson(DBNode node) {
		Json json = new Json();
		json.setInt("nodeId",node.nodeId);
		Json children = Json.parse("[]");
		//for(int i = 0; i < node.children.getSize(); i = i + 1) {
		int i = 0;
		while(i < node.children.getSize()) {
			children.add(this.PrivateArgumentTreeToJson(node.children[i]));
			i = i + 1;
		}
		json.set("children",children);
		return json;
	}

	Json ArgumentTreeToJson() {
		Json json = new Json();
		json.setInt("nodeId",this.root.nodeId);
		Json children = Json.parse("[]");
		//for(int i = 0; i < this.root.children.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.root.children.getSize()) {
			children.add(this.PrivateArgumentTreeToJson(this.root.children[i]));
			i = i + 1;
		}
		json.set("children",children);
		return json;
	}

	boolean AddNode(DBNode node) {
		//for(int i = 0; i < this.nodes.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.nodes.getSize()) {
			if(node.nodeId == this.nodes[i].nodeId) {
				return false;
			}
			i = i + 1;
		}
		this.nodes.add(node);
		return true;
	}

	void RemoveNode(DBNode node) {
		//for(int i = 0; i < this.nodes.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.nodes.getSize()) {
			if(node.nodeId == this.nodes[i].nodeId) {
				this.nodes.removeAt(i);
				break;
			}
			i = i + 1;
		}
	}

	@Public Json toJson() {
		Json json = new Json();
		json.set("root",this.root.toJson());
		json.set("nodes",this.DBNodeListToJson());
		json.set("links",this.ArgumentTreeToJson());
		return json;
	}
}

class Argument {
	int argumentId;
	int masterBranchId;
	Map[Branch] branches;
	Map[CommitLog] commits;

	Argument(int masterId, Branch branch) {
		this.branches = new Map[Branch];
		this.masterBranchId =masterId;
		this.branches.set(""+masterId, branch);
		this.commits.set(""+masterId, new CommitLog());
	}

	Commit Commit(String method, Json argument) {
		return this.commits.addCommit(method,argument);
	}

	@Public Branch GetBranch(int BranchId) {
		return this.branches.get(""+BranchId);
	}

	@Public Branch Fork(String originId, String newId, Context ctx) {
		this.Fork(originId, newId, ctx, this.GetBranch(originId).commitLog.head);
	}

	@Public Branch Fork(String originalId, String newId, Context ctx, String revision) {
		return new Branch(); //FIXME
	}

	DBNode GetDBNode(int nodeId) {
		return this.GetDBNode(this.masterBranchId, nodeId);
	}

	DBNode GetDBNode(int branchId, int nodeId) {
		return this.GetBranch(branchId).GetDBNode(nodeId);
	}

	void SetRoot(Goal g) {
		this.SetRoot(this.masterBranchId,g);
	}

	void SetRoot(int branchId, Goal g) {
		this.GetBranch(branchId).root = g;
	}

	DBNode GetRoot() {
		return this.GetBranch(this.masterBranchId).root;
	}

	Json toJson(int branchId) {
		Json json = this.GetBranch(branchId).toJson();
		CommitLog clog = this.commits.get(""+branchId);//FIXME wrapper
		json.set("CommitLog",clog.toJson());
		json.setString("HEAD",clog.head);
		json.setInt("argumentId",this.argumentId);
		json.setInt("branchId",branchId);
		return json;
	}

	Json toJson() {
		return this.toJson(this.masterBranchId);
	}
}

class DBDriver {
	DBDriver(){}

	Json getContext(int id) {
	}

	Argument GetArgument(int argumentId) {
	}

	//TODO args
	Argument CreateArgument() {
		System.p("aaaa");
	}

	//DBNode
	DBNode CreateDBNode(String nodeType, Json content) {
	}

	//TODO
	//void InsertCommit(String argument_name, String method, Commit c) {
	//}

	void InsertLink(int argumentId, int parentId, int childId) {
	}

	void addContext(int argumentId, int contextId, Json context) {
	}
	void UpdateDBNode(DBNode node, int argumentId, int branchId) {
	}
}

class DriverMySQL extends DBDriver {
	Connection con;
	int time;

	int GetID(){
		time = time + 1;
		return time;
	}

	DBDriver(String userName, String password) {
		this.con = new Connection("mysql://" + userName + ":" + password + "@localhost:3306");
		this.con.query("USE dcasedb;");
		this.time = new Date().getTime();
	}

	DBNode MakeNode(String NodeType, Json content) {
		if(NodeType == "Goal") {
			return new Goal(content);
		} else if (NodeType == "Strategy") {
			return new Strategy(content);
		} else if (NodeType == "Context") {
			return new Context(content);
		} else if (NodeType == "Evidence") {
			return new Evidence(content);
		}
		//return new DBNode();
	}

	Branch CreateBranch() {
		this.con.query("INSERT INTO Branch() VALUES()");
		Branch branch = new Branch();
		branch.branchId = this.con.getInsertId();
		return branch;
	}

	void UpdateBranch(Branch branch, int argumentId) {
		this.con.query("UPDATE Branch SET Argument_id=" + argumentId + " WHERE id=" + branch.branchId);
		branch.argumentId = argumentId;
	}

	Argument CreateArgument() {
		Branch branch = this.CreateBranch();
		this.con.query("INSERT INTO Argument(master_branch_id) VALUES("+branch.branchId+")");
		Argument argument = new Argument(branch.branchId, branch);
		argument.argumentId = this.con.getInsertId();
		this.UpdateBranch(branch,argument.argumentId);
		return argument;
	}

	int GetNodeType(String nodeType) {
		ResultSet nodeTypeId = this.con.query("SELECT id FROM NodeType WHERE type_name='" + nodeType + "'");
		int typeId;
		while(nodeTypeId.next()) {
			typeId = nodeTypeId.getInt("id");
		}
		return typeId;
	}

	DBNode CreateDBNode(String nodeType, Json content) {
		DBNode node = this.MakeNode(nodeType,content);
		int typeId = this.GetNodeType(nodeType);

		String description = content.getString("description");
		boolean isEvidence = content.getBoolean("isEvidence");
		String evidence = "FALSE";
		if(isEvidence) {
			evidence = "TRUE";
		}
		this.con.query("INSERT INTO DBNode(description,evidence_flag,nodeType_id) VALUES('"+ description + "'," + evidence + ","+typeId+") ");
		node.nodeId = this.con.getInsertId();
		return node;
	}

	void UpdateDBNode(DBNode node, int argumentId, int branchId) {
		this.con.query("UPDATE DBNode SET argument_id="+argumentId+", branch_id="+branchId+" WHERE id="+node.nodeId);
		node.argumentId = argumentId;
		node.branchId   = branchId;
	}
}

class API {
	Map[Argument] arguments;
	DBDriver db;

	API() {
		arguments = new Map[Argument];
	}

	API(String userName, String password) {
		this.Connect(userName, password);
	}

	void Connect(String userName, String password) {
		this.db = new DriverMySQL(userName, password);
	}

	@Public Argument CreateArgument(String description) {
		Json content = new Json();
		content.setString("description",description);
		content.setString("DBNodeType","Goal");

		Argument argument = this.db.CreateArgument();
		this.arguments.set(""+argument.argumentId, argument);

		Goal g = this.CreateDBNode(argument.argumentId,content) as Goal;
		argument.SetRoot(g);
		return argument;
	}

	@Public Argument GetArgument(int argumentId) {
		return this.arguments.get(""+argumentId);
	}

	@Public String[] GetArgumentIds() {
		return this.arguments.keys(); //FIXME
	}

	@Public DBNode[] SearchDBNode(String searchText) {
		return []; //FIXME
	}

	@Public DBNode CreateDBNode(int argumentId, Json content) {
		String NodeType = content.getString("DBNodeType");
		return this.db.CreateDBNode(NodeType,content);
	}

	@Public void InsertLink(int id, DBNode parentId, DBNode childId) {
		int masterId = this.GetArgument(id).masterBranchId;
		this.InsertLink(id, masterId, parentId, childId);
	}

	@Public void InsertLink(int id, int branchId, DBNode parent, DBNode child) {
		Branch branch = this.GetArgument(id).GetBranch(branchId);
		if(branch.AddNode(parent)){
			this.db.UpdateDBNode(parent,id,branchId);
		}
		if(branch.AddNode(child)){
			this.db.UpdateDBNode(child,id,branchId);
		}
		parent.addChild(child);
		//TODO Commit
	}

	//FIXME Json contents
	@Public void UpdateDBNode(int argumentId, DBNode node, Json contents) {
		int masterId = this.GetArgument(id).masterBranchId;
		this.UpdateDBNode(argumentId, masterId, node, contents);
	}

	@Public void UpdateDBNode(String argumentId, String branchId, DBNode node, Json contents) {
		node.Update(contents);
		//TODO Commit Log
	}

	@Public void UpdateParentLink(DBNode oldParent, DBNode newParent, DBNode node) {
		oldParent.RemoveChild(node);
		newParent.AddChild(node);
	}

	@Public void UpdateChildLink(DBNode node, DBNode oldChild, DBNode newChild) {
		node.RemoveChild(oldChild);
		node.AddChild(newChild);
	}

	@Public void DeleteDBNode(String argumentId, String nodeId) {
		this.DeleteDBNode(argumentId, "master", nodeId);
	}

	@Public void DeleteDBNode(String argumentId, String branchId, String nodeId) {
		Branch branch = this.GetArgument(argumentId).GetBranch(branchId);
		DBNode node = branch.GetDBNode(ndoeId);
		branch.RemoveNode(node);
	}

	@Public void DeleteLink(String argumentId, String parentId, String childId) {
		this.DeleteLink(argumentId, "master", parentId, childId);
	}

	@Public void DeleteLink(String argumentId, String branchId, String parentId, String childId) {
		//TODO
	}

	@Public void AddContext(String argumentId, String nodeId, Json context) {
		this.AddContext(argumentId, "master", nodeId, context);
	}

	@Public void AddContext(String argumentId, String branchId, String nodeId, Json context) {
		DBNode node = this.GetArgument(argumentId).GetBranch(branchId).GetDBNode(nodeId);
		node.addContext(context);
	}
}
