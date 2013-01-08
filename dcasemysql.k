import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
import("konoha.sql");

class DBDriver {
	Connection con;

	DBDriver(String name, String passwd) {
		this.con = new Connection("mysql://" + name + ":" + passwd + "@localhost:3306");
		this.con.query("USE dcasedb");
	}

	Argument SearchArgument(String name) {
		String sql = "SELECT id,name,description,evidence_flag,type_name FROM DBNode, WHERE  AND DBNode.argument_id=Argument.id";
	}
}
