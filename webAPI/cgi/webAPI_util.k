import("Type.Json");
import("Syntax.CStyleWhile");
import("Syntax.Null");
import("Java.Class");
import("posix.process");
import("Type.File");

Load("funcmap.k");

boolean checkVersion(int version) {
	boolean ret = false;
	if (version == 1) {
		ret = true;
	}
	else {
	}
	return ret;
}

boolean checkID(Json j) {
	return j.hasKey("id");
}

String getMsg() {
	String mtd_type = System.getenv("REQUEST_METHOD");
	if (mtd_type != "POST") {
		// ERROR Handling: only POST Method is available
	}
	String query;
	String ln;
	FILE f = stdin;
	while ((ln = f.readLine()) != null) {
		query = query + ln;
	}
	return query;
}

void flush(String str) {
	String result = "Content-Type: application/json; charset=utf-8\n\n";
	result = result + str;
	stdout.write(result);
}
