package interface

import scalafx.beans.property.{BooleanProperty, StringProperty}
import scalafx.collections.ObservableBuffer

import database._
import database.Parameters.Result

object InsertBean {

  val attributes = ObservableBuffer[String]()
  val table = StringProperty("")
  var values = List[StringProperty]()

  def setAttributes(newAttributes: List[String]): Unit = {
    values = Nil
    for (i <- newAttributes) {
      values = StringProperty("") :: values
    }
    attributes.clear()
    attributes ++= newAttributes
  }
}
