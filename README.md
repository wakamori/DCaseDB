# DCase DB

## API
* DCaseRepository Class
    * DCaseRepository DCaseRepository.new()
    * DBNode[] SearchDBNode(DBNode root, String searchText) //TODO return type
    * DBNode   CreateDBNode(int DBNodeType, Json content)
    * void     InsertDBNode(String parent, String child)
    * void     UpdateDBNode(DBNode node, Json contents) //TODO diff
    * void     DeleteDBNode(DBNode parent, DBNode child) //TODO
    * Tree     searchTree(String searchText) //TODO
    * void     Connect() //TODO
    * void     CreateTree() //TODO Commit log
* Tree Class
    * Json   toJson()
