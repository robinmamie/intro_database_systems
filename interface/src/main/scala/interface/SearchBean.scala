package interface

import scalafx.beans.property.{BooleanProperty, StringProperty}
import scalafx.collections.ObservableBuffer

import database._
import database.Parameters.Result

object SearchBean {

  class Item(initialSelection: Boolean, val name: String) {
    val selected = BooleanProperty(initialSelection)
    override def toString = name
  }

  val searchTables = ObservableBuffer[Item](
    Parameters.tableNames.map { n => new Item(false, n) }
  )

  val searchText = StringProperty("")
  val results = ObservableBuffer[Result]()

  def setResults(newResults: List[Result]): Unit = {
    results.clear()
    results ++= newResults
  }
}
