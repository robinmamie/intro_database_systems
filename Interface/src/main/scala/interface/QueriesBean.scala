package interface

import scalafx.beans.property.{BooleanProperty, StringProperty}
import scalafx.collections.ObservableBuffer

import database._
import database.Parameters.Result

object QueriesBean {

  class Item(initialSelection: Boolean, val name: String, val file: String) {
    val selected = BooleanProperty(initialSelection)
    override def toString = name
  }

  val queries = ObservableBuffer[Item](
    (1 to 10).map { t => new Item(false, "Query nb. " + t, "sql/" + t + ".sql") }
  )

  val results = ObservableBuffer[Result]()

  def setResults(newResults: List[Result]): Unit = {
    results.clear()
    results ++= newResults
  }
}
