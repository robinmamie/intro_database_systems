package database

import database.Parameters.Result

object Lookup {

  def allAttributes(toSearch: String): List[Result] = {
    allAttributes(toSearch, Parameters.tableNames)
  }

  def allAttributes(toSearch: String, tables: List[String]): List[Result] = {
    tables map { t =>
      List(List())
    }
  }

}
