package database

import java.sql._

import oracle.jdbc.pool.OracleDataSource

object DatabaseLink {

  val host = "cs322-db.epfl.ch"
  val port = 1521
  val sid  = "ORCLCDB"
  val user = "C##DB2019_G11"
  val pass = "DB2019_G11"

  val ods = new OracleDataSource()
  ods.setUser(user)
  ods.setPassword(pass)
  ods.setURL("jdbc:oracle:thin:@" + host + ":" + port + "/" + sid)

  def fetch(query: String) = {
    println("Connecting...")
    val con = ods.getConnection()
    println("Connected to database")

    println("Executing statement " + query)

    println("### START OF STATEMENT ###")
    val statement = con.createStatement()
    val resultSet = statement.executeQuery(query)
    while (resultSet.next()) {
      val user = resultSet.getString("user_id")
      println("user = " + user)
    }
    println("### END OF STATEMENT ###")

    statement.close()
    con.close()
    println("Connection closed")
  }

}
