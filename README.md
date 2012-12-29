# DCase DB

## API
* DCaseRepository Class
    * DCaseRepository DCaseRepository.new()

    * DBNode CreateDBNode(String TreeName, int DBNodeType, Json content)
    * void   InsertLink(String TreeName, String parent, String child)
    * void   UpdateDBNode(String TreeName, DBNode node, Json contents)
    * void   UpdateParentLink(String Treename, String parent_old, String parent_new, String child)
    * void   UpdateChildLink(String TreeName, String parent, String child_old, String child_new)
    * void   DeleteDBNode(String TreeName, String node)
    * void   DeleteLink(String TreeName, String parent, String child)
    * DBNode SearchDBNode(String TreeName, String searchText)
    * Tree   SearchTree(String TreeName)
    * void   Connect() //TODO
    * void   CreateTree(String name) //FIXME

* Tree Class
    * Json   toJson()
