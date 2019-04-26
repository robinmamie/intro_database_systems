package database

object Parameters {

  type Result = List[List[String]]

  val tableNames = DatabaseLink.fetch("SELECT table_name FROM user_tables", false).flatten

  val attributeNames = tableNames.map { t =>
    DatabaseLink.fetch(s"SELECT column_name FROM user_tab_columns WHERE table_name = '${t}' AND data_type != 'DATE'", false).flatten
  }

  val tables = tableNames zip attributeNames

  def getAttributes(table: String) = {
    tables.filter( _._1 == table).head._2
  }

  /*
  val primaryAttributes = tableNames.map { t =>
    DatabaseLink.fetch(s"SELECT cols.table_name, cols.column_name, cols.position, cons.status, cons.owner FROM all_constraints cons, all_cons_columns col WHERE cols.table_name = '${t}' AND cons.constraint_type = 'P' AND cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner ORDER BY cols.table_name, cols.position;", false).flatten
  }
  */

}
