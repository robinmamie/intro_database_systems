package database

import java.sql._

import oracle.jdbc.pool.OracleDataSource

import database.Parameters.Result

object DatabaseLink {

  val host = "cs322-db.epfl.ch"
  val port = 1521
  val sid  = "ORCLCDB"
  private val user = "C##DB2019_G11"
  private val pass = "DB2019_G11"

  private val ods = new OracleDataSource()
  ods.setUser(user)
  ods.setPassword(pass)
  ods.setURL("jdbc:oracle:thin:@" + host + ":" + port + "/" + sid)

  println("Connecting...")
  private val con = ods.getConnection()
  println("Connected to database")

  def fetch(query: String): Result = {
    println("Executing statement " + query)

    val statement = con.createStatement()
    val resultSet = statement.executeQuery(query)
    val meta = resultSet.getMetaData()
    val columnCount = meta.getColumnCount()
    val allColumns = ((1 to columnCount) map (i => meta.getColumnName(i))).toList

    var results = List(allColumns)
    while (resultSet.next()) {
      val line = ((1 to columnCount) map (i => resultSet.getString(i))).toList
      results = line :: results
    }
    println("Finished executing the statement.")

    statement.close()

    results.reverse
  }

}
