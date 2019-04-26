package interface

import scalafx.beans.property.ObjectProperty
import scalafx.collections.ObservableBuffer
import scalafx.scene.layout.Pane

import database._
import database.Parameters.Result

object InstanceBean {

  val instance = ObservableBuffer[List[String]]()

  var previousWindow: Pane = _

  def setInstance(newInstance: Result): Unit = {
    instance.clear()
    instance ++= newInstance
  }
}
