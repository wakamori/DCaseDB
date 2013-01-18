#!/usr/local/bin/minikonoha

//Import("Type.File");
import("cstyle.file");
load("dcasedb_glue.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	stdout.println("Content-type: application/json; charset=UTF-8\n\n");
	stdout.println(repo.SearchArgument(TreeName).toJson());
}

main();
