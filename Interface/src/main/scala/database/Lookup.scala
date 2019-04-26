package database

import database.Parameters.Result

object Lookup {

  def allAttributes(toSearch: String): List[Result] = {
    allAttributes(toSearch, Parameters.tableNames)
  }

  def allAttributes(toSearch: String, tables: List[String]): List[Result] = {
    //val tableNames = DatabaseLink.fetch(s"SELECT * FROM user_tables").flatten.drop(1)
    //print(tableNames)
    tables map { t =>
      List(List("id"), List("1234"), List("786345"))
    }
  }

}
