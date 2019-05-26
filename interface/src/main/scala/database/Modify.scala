package database

import database.Parameters.Result

object Modify {

  def insert(table: String, values: List[String]): Unit = {
    val sb = new StringBuilder
    sb ++= s"INSERT INTO ${table} VALUES ("
    for (v <- values) sb ++= s"""'${v}', """
    DatabaseLink.execute(sb.toString.dropRight(2) + ")")
  }

  def delete(table: String, values: List[String]): Unit = {
    var valid = false
    val param = Parameters.getAttributes(table) zip values
    val sb = new StringBuilder
    sb ++= s"DELETE FROM ${table} WHERE"
    for ((att, v) <- param) {
      if (!v.isEmpty) {
        sb ++= s""" ${att}='${v}' AND"""
        valid = true
      }
    }
    if (valid) DatabaseLink.execute(sb.toString.dropRight(4))
  }

}
