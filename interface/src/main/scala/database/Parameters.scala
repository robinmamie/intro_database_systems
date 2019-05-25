package database

object Parameters {

  type Result = List[List[String]]

  val tableNames = DatabaseLink.fetch("SELECT table_name FROM user_tables", false).flatten

  val attributeNames = tableNames.map { t =>
    DatabaseLink.fetch(s"SELECT column_name FROM user_tab_columns WHERE table_name = '${t}'", false).flatten
  }

  val tables = tableNames zip attributeNames

  def getAttributes(table: String) = {
    tables.filter( _._1 == table).head._2
  }

  val primaryAttributes = DatabaseLink.getPrimaryKeys()
  
  def getPrimaryAttributes(table: String): List[String] = {
    primaryAttributes.filter(_._1 == table).map{ case (t,k) => k }
  }

}
