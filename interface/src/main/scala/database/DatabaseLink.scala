package database

import scala.collection.mutable;

import java.sql._

import oracle.jdbc.pool.OracleDataSource

import database.Parameters.Result
import interface.GlobalBean

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

  def fetch(query : String): Result = fetch(query, true)

  def fetch(query: String, header: Boolean): Result = {
    fetch(query, header, GlobalBean.requests().toInt)
  }

  def fetch(query: String, header: Boolean, nb: Int): Result = {
    println("Executing statement " + query)

    val statement = con.createStatement()
    val resultSet = statement.executeQuery(query)
    val meta = resultSet.getMetaData()
    val columnCount = meta.getColumnCount()
    val allColumns = ((1 to columnCount) map (i => meta.getColumnName(i))).toList

    var results = if (header ) List(allColumns) else List()
    var i = nb
    while (resultSet.next() && i != 0) {
      val line = for (i <- 1 to columnCount) yield resultSet.getString(i)
      results = line.toList :: results
      i -= 1
    }
    println("Finished executing the statement.")

    statement.close()

    results.reverse
  }

  def execute(update: String): Unit = {
    println("Executing update " + update)
    val statement = con.createStatement()
    val resultSet = statement.executeUpdate(update)
    statement.close()
  }

  def getPrimaryKeys(): List[(String, String)] = {

    var pKeys: List[(String, String)] = List()
    val statement = con.createStatement()
    val tables = statement.executeQuery("SELECT table_name FROM user_tables");
    val meta = con.getMetaData
    while (tables.next()) {
      val tableName = tables.getString("TABLE_NAME")
      val keys = meta.getPrimaryKeys(null,null,tableName)
      while (keys.next()) {
        pKeys = (tableName, keys.getString("COLUMN_NAME")) :: pKeys
      }
      keys.close()
    }
    tables.close()
    statement.close()
    return pKeys
  }

}
