package database

object Parameters {

  type Result = List[List[String]]

  val tableNames = DatabaseLink.fetch("SELECT table_name FROM user_tables").flatten.drop(1)

}
