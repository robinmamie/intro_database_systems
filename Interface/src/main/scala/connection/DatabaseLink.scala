package database

import java.sql._

import oracle.jdbc.pool.OracleDataSource

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

  private def connect(): Connection = {
    println("Connecting...")
    val connection = ods.getConnection()
    println("Connected to database")
    connection
  }

  def fetch(query: String, columns: List[String]): List[List[String]] = {
    val con = connect()

    println("Executing statement " + query)

    val statement = con.createStatement()
    val resultSet = statement.executeQuery(query)

    var results = List(columns)
    while (resultSet.next()) {
      val line = for (c <- columns) yield resultSet.getString(c)
      results = line :: results
    }
    println("Finished executing the statement.")

    statement.close()
    con.close()
    println("Connection closed")

    results.reverse
  }

}
