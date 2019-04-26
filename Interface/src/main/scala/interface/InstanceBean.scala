package interface

import scalafx.beans.property.StringProperty
import scalafx.collections.ObservableBuffer
import scalafx.scene.layout.Pane

import database._
import database.Parameters.Result

object InstanceBean {

  val instance = ObservableBuffer[List[StringProperty]]()

  var previousWindow: Pane = _

  def setInstance(newInstance: Result): Unit = {
    instance.clear()
    for (row <- newInstance) {
      var line: List[StringProperty] = List()
      for (e <- row) {
        line = StringProperty(e) :: line
      }
      instance += line.reverse
    }
  }

}
