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
        var info = ""
        var count = 0
        if (e != null) {
          for (c <- e) {
            if (count > 100 && c == ' ') {
              info += '\n'
              count = 0
            } else {
              info += c
              count += 1
            }
          }
        }
        line = StringProperty(info) :: line
      }
      instance += line.reverse
    }
  }

}
